import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:sentry/sentry.dart';

import '../helpers/enum_helper.dart';

class AppUser {
  @required
  String id;
  @required
  String name;
  @required
  String address;
  @required
  String mobileNumber;
  @required
  String pincode;
  @required
  String email;
  @required
  int points;

  AppUser({
    required this.address,
    required this.id,
    required this.mobileNumber,
    required this.name,
    required this.pincode,
    required this.email,
    required this.points,
  });
}

class AppUserProvider with ChangeNotifier {
  final _cloud = FirebaseFirestore.instance;
  AppUser? _appUser;
  List<Map<String, dynamic>> _emails = [];

  List<Map<String, dynamic>> get emails {
    return _emails;
  }

  AppUser? get appUser {
    return _appUser;
  }

  Future<ProviderResponse> getUser(String mobileNumber) async {
    try {
      final result = await _cloud
          .collection('ambassador')
          .where('mobileNumber', isEqualTo: mobileNumber)
          .get();
      final data = result.docs.first.data();
      _appUser = AppUser(
        address: data["address"],
        email: data["email"],
        id: result.docs.first.id,
        points: data["points"],
        mobileNumber: data["mobileNumber"],
        name: data["name"],
        pincode: data["pincode"],
      );
      notifyListeners();
      return ProviderResponse.success;
    } catch (e) {
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }

  Future<ProviderResponse> checkUser(String mobileNumber) async {
    try {
      final result = await _cloud
          .collection('ambassador')
          .where('mobileNumber', isEqualTo: mobileNumber)
          .get();
      if (result.docs.isNotEmpty) {
        final data = result.docs.first.data();
        _appUser = AppUser(
          address: data["address"],
          email: data["email"],
          id: result.docs.first.id,
          points: data["points"],
          mobileNumber: data["mobileNumber"],
          name: data["name"],
          pincode: data["pincode"],
        );
        notifyListeners();
        return ProviderResponse.userExists;
      } else {
        return ProviderResponse.userDoesnotExist;
      }
    } catch (e) {
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }

  Future<ProviderResponse> changeUserMobileNumber(String mobileNumber) async {
    try {
      await _cloud
          .collection('ambassador')
          .doc(_appUser!.id)
          .update({"mobileNumber": mobileNumber});
      return ProviderResponse.success;
    } catch (e) {
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }

  Future<ProviderResponse> checkAppStatus() async {
    try {
      final response = await _cloud
          .collection('config')
          .where('flag', isEqualTo: true)
          .get();
      if (response.docs.first.data()["maintenance"] == false) {
        return ProviderResponse.success;
      } else {
        return ProviderResponse.underMaintainence;
      }
    } catch (e) {
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }

  Future<ProviderResponse> updateUser(AppUser appUser) async {
    try {
      await _cloud.collection('ambassador').doc(_appUser!.id).update({
        "address": appUser.address,
        "name": appUser.name,
        "pincode": appUser.pincode,
        "email": appUser.email
      });
      _appUser!.name = appUser.name;
      _appUser!.address = appUser.address;
      _appUser!.pincode = appUser.pincode;
      _appUser!.email = appUser.email;
      return ProviderResponse.success;
    } catch (e) {
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }

  Future<ProviderResponse> getModeratorEmails() async {
    try {
      final response = await _cloud
          .collection('config')
          .where('flag', isEqualTo: true)
          .get();
      if (response.docs.isNotEmpty) {
        final data = response.docs.first.data();
        _emails = List<Map<String, dynamic>>.from(data["moderator"]);
        notifyListeners();
      }
      return ProviderResponse.success;
    } catch (e) {
      print(e);
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }

  void clear() {
    _appUser = null;
    notifyListeners();
  }
}
