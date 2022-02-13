enum ProviderResponse {
  success,
  error,
  userExists,
  userDoesnotExist,
  wrongOtp,
  underMaintainence,
  vendorExists
}

enum VendorStatus { pending, approved, rejected }

String vendorStatusToString(VendorStatus vendorStatus) {
  if (vendorStatus == VendorStatus.approved) {
    return 'Approved';
  } else if (vendorStatus == VendorStatus.rejected) {
    return 'Rejected';
  }
  return 'Pending';
}

VendorStatus stringTovendorStatus
(String vendorStatus) {
  if (vendorStatus == 'Approved') {
    return VendorStatus.approved;
  } else if (vendorStatus == 'Rejected') {
    return VendorStatus.rejected;
  }
  return VendorStatus.pending;
}
