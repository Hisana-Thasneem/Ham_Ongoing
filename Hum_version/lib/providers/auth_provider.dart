import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/reusables_helper.dart';
import '../helpers/enum_helper.dart';
import '../pages/login_page.dart';
import '../pages/home_page.dart';

class AuthProvider with ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  User? _user;

  User? get user {
    return _user ?? _auth.currentUser;
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    _user = null;
    Navigator.of(context).pushReplacementNamed(LoginPage.routeName);
  }

  static StreamBuilder<User?> handleAuth() {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user != null ? const HomePage() : const LoginPage();
        }
        return loader(context);
      },
    );
  }

  Future<ProviderResponse> signIn(AuthCredential authCredential) async {
    try {
      await _auth.signInWithCredential(authCredential);
      notifyListeners();
      return ProviderResponse.success;
    } catch (e) {
      if (e.toString().contains('invalid-verification-code')) {
        return ProviderResponse.wrongOtp;
      }
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }

  Future<ProviderResponse> signInWithOTP(
      {required String verificationId, required String smsCode}) async {
    try {
      AuthCredential authCred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      final otpVerify = await signIn(authCred);
      if (otpVerify == ProviderResponse.wrongOtp) {
        notifyListeners();
        return ProviderResponse.wrongOtp;
      } else if (otpVerify == ProviderResponse.error) {
        notifyListeners();
        return ProviderResponse.error;
      } else {
        notifyListeners();
        return ProviderResponse.success;
      }
    } catch (e) {
      // await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }
}
