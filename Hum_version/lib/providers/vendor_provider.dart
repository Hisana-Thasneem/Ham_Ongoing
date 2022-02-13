import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:sentry/sentry.dart';

import '../helpers/enum_helper.dart';

class Vendor {
  String? id;
  @required
  String shopName;
  @required
  String mobileNumber;
  @required
  String address;
  @required
  String pincode;
  @required
  String licenseNumber;
  @required
  String ownerName;
  @required
  VendorStatus status;
  @required
  String ambassadorId;
  @required
  String reason;
  @required
  String email;
  String? addedDate;
  String? actionDate;

  Vendor({
    this.id,
    required this.address,
    required this.licenseNumber,
    required this.mobileNumber,
    required this.ownerName,
    required this.pincode,
    required this.shopName,
    required this.status,
    required this.ambassadorId,
    required this.reason,
    required this.email,
    this.addedDate,
    this.actionDate,
  });
}

class VendorProvider with ChangeNotifier {
  final _cloud = FirebaseFirestore.instance;
  List<Vendor> _pendingVendors = [];
  List<Vendor> _approvedVendors = [];
  List<Vendor> _rejectedVendors = [];

  List<Vendor> get pendingVendors {
    return _pendingVendors;
  }

  List<Vendor> get approvedVendors {
    return _approvedVendors;
  }

  List<Vendor> get rejectedVendors {
    return _rejectedVendors;
  }

  Future<ProviderResponse> addVendor(Vendor vendor) async {
    try {
      final response = await _cloud
          .collection('ambassadorVendor')
          .where('mobileNumber', isEqualTo: vendor.mobileNumber)
          .get();
      if (response.docs.isNotEmpty) {
        return ProviderResponse.vendorExists;
      } else {
        final data = {
          "shopName": vendor.shopName,
          "address": vendor.address,
          "licenseNumber": vendor.licenseNumber,
          "mobileNumber": vendor.mobileNumber,
          "ownerName": vendor.ownerName,
          "pincode": vendor.pincode,
          "status": vendorStatusToString(vendor.status),
          "reason": vendor.reason,
          "ambassadorId": vendor.ambassadorId,
          "email": vendor.email,
          "addedDate": vendor.addedDate,
          "actionDate": vendor.actionDate,
        };
        final docId = await _cloud.collection('ambassadorVendor').add(data);
        vendor.id = docId.id;
        _pendingVendors.add(vendor);
        return ProviderResponse.success;
      }
    } catch (e) {
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }

  Future<ProviderResponse> getVendors(String ambassadorId) async {
    try {
      final response = await _cloud
          .collection('ambassadorVendor')
          .where('ambassadorId', isEqualTo: ambassadorId)
          .get();
      if (response.docs.isNotEmpty) {
        _pendingVendors = [];
        _approvedVendors = [];
        _rejectedVendors = [];
        for (var doc in response.docs) {
          Vendor vendor = Vendor(
            id: doc.id,
            address: doc.data()["address"],
            licenseNumber: doc.data()["licenseNumber"],
            mobileNumber: doc.data()["mobileNumber"],
            ownerName: doc.data()["ownerName"],
            pincode: doc.data()["pincode"],
            shopName: doc.data()["shopName"],
            status: stringTovendorStatus(doc.data()["status"]),
            ambassadorId: ambassadorId,
            reason: doc.data()["reason"],
            email: doc.data()["email"],
            actionDate: doc.data()["actionDate"],
            addedDate: doc.data()["addedDate"],
          );
          if (vendor.status == VendorStatus.pending) {
            _pendingVendors.add(vendor);
          } else if (vendor.status == VendorStatus.rejected) {
            _rejectedVendors.add(vendor);
          } else {
            _approvedVendors.add(vendor);
          }
        }
      }
      notifyListeners();
      return ProviderResponse.success;
    } catch (e) {
      //await Sentry.captureException(e);
      return ProviderResponse.error;
    }
  }
}
