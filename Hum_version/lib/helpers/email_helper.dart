import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
//import 'package:sentry/sentry.dart';

import '../providers/app_user_provider.dart';
import '../providers/vendor_provider.dart';
import './enum_helper.dart';

final _apiKey =
    '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';

Future<ProviderResponse> sendEmail(Vendor vendor, BuildContext context) async {
  try {
    final appUserProvider =
        Provider.of<AppUserProvider>(context, listen: false);
    final response = await http.post(
      Uri.https('api.sendgrid.com', '/v3/mail/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode(
        {
          'personalizations': [
            {'to': appUserProvider.emails}
          ],
          'from': {'email': 'bazaarhum@gmail.com'},
          'subject':
              'Ambassador: ${appUserProvider.appUser!.name} has added a new Vendor!',
          'content': [
            {
              'type': 'text/plain',
              'value':
                  'Ambassador with Name ${appUserProvider.appUser!.name} and ID ${appUserProvider.appUser!.id} has added a new Vendor. Other details of the added vendor are:\n\nAddress : ${vendor.address}\nShop Name : ${vendor.shopName}\nMobile Number : ${vendor.mobileNumber}\nOwner Name : ${vendor.ownerName}\nLicense Number : ${vendor.licenseNumber}',
            }
          ]
        },
      ),
    );
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      return ProviderResponse.success;
    }
    return ProviderResponse.error;
  } catch (e) {
    //await Sentry.captureException(e);
    return ProviderResponse.error;
  }
}
