import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../helpers/reusables_helper.dart';
import '../helpers/enum_helper.dart';
import '../providers/app_user_provider.dart';
import '../providers/auth_provider.dart';
import './login_page.dart';
import './home_page.dart';

class LoginOtpPage extends StatefulWidget {
  static const routeName = '/loginotppage';

  const LoginOtpPage({Key? key}) : super(key: key);
  @override
  _LoginOtpPageState createState() => _LoginOtpPageState();
}

class _LoginOtpPageState extends State<LoginOtpPage> {
  String? _verificationId;
  bool _isLoading = false;
  bool _isInit = true;

  Future<void> _sendOtp() async {
    PhoneVerificationCompleted? verified(AuthCredential credential) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<AuthProvider>(context, listen: false)
          .signIn(credential)
          .then((value) {
        if (value == ProviderResponse.wrongOtp) {
          setState(() {
            _isLoading = false;
          });
          displaySnackBar(
            context: context,
            text: 'You have entered the wrong OTP.',
          );
        } else if (value == ProviderResponse.error) {
          setState(() {
            _isLoading = false;
          });
          displaySnackBar(
            context: context,
            text:
                'An unexpected error had occured while autoretreival, please check your internet connection or try again.',
          );
        } else if (value == ProviderResponse.success) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        }
      });
    }

    PhoneVerificationFailed? notVerified(FirebaseAuthException exception) {
      alert(
          context: context,
          title: 'An unexpected error had occured!',
          content:
              'An unexpected error had occured, please check your internet connection or try again. \n ERR_MSG:${exception.message}');
    }

    PhoneCodeSent? smsSent(String verId, int? forceResend) {
      _verificationId = verId;
    }

    final _auth = FirebaseAuth.instance;
    await _auth.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber:
          '+91${Provider.of<AppUserProvider>(context, listen: false).appUser!.mobileNumber}',
      verificationCompleted: verified,
      verificationFailed: notVerified,
      codeSent: smsSent,
      codeAutoRetrievalTimeout: (verId) {
        displaySnackBar(
          context: context,
          text: 'OTP auto retrieval failed.',
        );
      },
    );
  }

  void _verifyOtp(String verId, String otp) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<AuthProvider>(context, listen: false)
        .signInWithOTP(verificationId: verId, smsCode: otp)
        .then((value) {
      if (value == ProviderResponse.wrongOtp) {
        setState(() {
          _isLoading = false;
        });
        displaySnackBar(
          context: context,
          text: 'You have entered a wrong OTP.',
        );
      } else if (value == ProviderResponse.error) {
        setState(() {
          _isLoading = false;
        });
        displaySnackBar(
          context: context,
          text:
              'An unexpected error had occured while veryfying OTP, please check your internet connection or try again.',
        );
      } else if (value == ProviderResponse.success) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _sendOtp().then((value) {
        displaySnackBar(
          context: context,
          text: 'OTP has been sent successfully.',
        );
        setState(() {
          _isInit = false;
          _isLoading = false;
        });
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _isLoading
          ? loader(context)
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 65),
                      child: Text(
                        'Hum Bazaar',
                        style: GoogleFonts.openSans(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.white,
                    margin: const EdgeInsets.fromLTRB(20, 50, 20, 0),
                    elevation: 5.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                    ),
                    child: SizedBox(
                      height: 530,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Enter OTP',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.openSans(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold),
                            ),
                            OTPTextField(
                                keyboardType: TextInputType.number,
                                length: 6,
                                width: double.infinity,
                                fieldWidth: 30,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                textFieldAlignment:
                                    MainAxisAlignment.spaceAround,
                                fieldStyle: FieldStyle.underline,
                                otpFieldStyle: OtpFieldStyle(
                                  focusBorderColor:
                                      Theme.of(context).primaryColor,
                                ),
                                onCompleted: (pin) {
                                  _verifyOtp(_verificationId!, pin);
                                }),
                            Text(
                              'OTP has been successfully sent to +91${Provider.of<AppUserProvider>(context, listen: false).appUser!.mobileNumber}',
                              style: GoogleFonts.openSans(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () {
                                _sendOtp().then((value) {
                                  displaySnackBar(
                                    context: context,
                                    text: 'OTP has been resent successfully.',
                                  );
                                });
                              },
                              child: Text(
                                'RESEND OTP',
                                style: GoogleFonts.openSans(
                                  color: Theme.of(context).accentColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Provider.of<AppUserProvider>(context,
                                        listen: false)
                                    .clear();
                                Navigator.of(context).pushReplacementNamed(
                                  LoginPage.routeName,
                                );
                              },
                              child: Text(
                                'CHANGE NUMBER',
                                style: GoogleFonts.openSans(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
