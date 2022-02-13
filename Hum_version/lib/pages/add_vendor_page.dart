import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helpers/reusables_helper.dart';
import '../helpers/email_helper.dart';
import '../helpers/enum_helper.dart';
import '../providers/vendor_provider.dart';
import '../providers/app_user_provider.dart';

class AddVendorPage extends StatefulWidget {
  static const routeName = '/addvendorpage';

  const AddVendorPage({Key? key}) : super(key: key);
  @override
  _AddVendorPageState createState() => _AddVendorPageState();
}

class _AddVendorPageState extends State<AddVendorPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _mobileNumber = TextEditingController();
  final _shopName = TextEditingController();
  final _pincode = TextEditingController();
  final _licenseNumber = TextEditingController();
  bool _isLoading = false;
  bool _isInit = true;

  void _addVendor() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final vendor = Vendor(
        address: _address.text,
        licenseNumber: _licenseNumber.text,
        mobileNumber: _mobileNumber.text,
        ownerName: _name.text,
        pincode: _pincode.text,
        shopName: _shopName.text,
        ambassadorId:
            Provider.of<AppUserProvider>(context, listen: false).appUser!.id,
        email: _email.text,
        reason: "",
        status: VendorStatus.pending,
        actionDate: "",
        addedDate: DateTime.now().toString(),
      );
      final response = await Provider.of<VendorProvider>(context, listen: false)
          .addVendor(vendor);
      if (response == ProviderResponse.vendorExists) {
        setState(() {
          _isLoading = false;
        });
        alert(
          context: context,
          title: "Vendor Already Exists!",
          content:
              "The vendor with provided details already exists in Hum Bazzar",
        );
      } else if (response == ProviderResponse.success) {
        sendEmail(vendor, context).then((response) {
          setState(() {
            _isLoading = false;
          });
          if (response == ProviderResponse.error) {
            alert(
              context: context,
              title: 'Vendor details submitted successfully!',
              content:
                  'The vendor details were submitted successfully but we couldn\'t notify the admins due to some error! Please wait until we process your request and if you don\'t get a response within 3 working days, please contact suport.',
              closePage: true,
            );
          } else {
            alert(
              context: context,
              title: 'Vendor details submitted successfully!',
              content:
                  'The vendor details were submitted successfully! Please wait until we process your request.',
              closePage: true,
            );
          }
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        displaySnackBar(
          context: context,
          text:
              'An unexpected error had occured while adding sending vendor details, please check your internet connection or try again.',
        );
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
        _isInit = false;
      });
      Provider.of<AppUserProvider>(context, listen: false)
          .getModeratorEmails()
          .then((value) {
        setState(() {
          _isLoading = false;
        });
        if (value != ProviderResponse.success) {
          alert(
            context: context,
            closePage: true,
            title: 'An error had occured!',
            content:
                'An unexpected error had occured while fetching mails, please check your internet connection or try again.',
          );
        }
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _email.dispose();
    _shopName.dispose();
    _mobileNumber.dispose();
    _licenseNumber.dispose();
    _pincode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: appbar(
        child: Text(
          'ADD VENDOR',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.w500,
            fontSize: MediaQuery.of(context).size.width > 390 ? 20 : 16,
          ),
        ),
      ),
      body: _isLoading
          ? loader(context)
          : Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 50.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _name,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                hintText: 'Enter your name',
                                labelText: 'Name',
                              ),
                              validator: (val) {
                                if ((RegExp(r'[0-9,-/#;*+()!@#_-]')
                                        .hasMatch(val!) ||
                                    (val.trim().length < 2))) {
                                  return 'Enter a valid name';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              controller: _shopName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                hintText: 'Enter your shop name',
                                labelText: 'Shop Name',
                              ),
                              validator: (val) {
                                if ((RegExp(r'[0-9,-/#;*+()!@#_-]')
                                        .hasMatch(val!) ||
                                    (val.trim().length < 2))) {
                                  return 'Enter a valid shop name';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              controller: _address,
                              maxLines: 4,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                hintText: 'Enter your address',
                                labelText: 'Address',
                              ),
                              validator: (val) {
                                return (val!.isEmpty)
                                    ? 'Please provide an address'
                                    : null;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              controller: _pincode,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                hintText: 'Enter your pincode',
                                labelText: 'Pincode',
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Please enter a pincode';
                                } else if (RegExp(r'[a-zA-Z,.-/#;*+()]')
                                    .hasMatch(value)) {
                                  return 'Enter a valid pincode';
                                } else if (value.trim().length != 6) {
                                  return 'Pincode should be a six digit number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              controller: _mobileNumber,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                hintText: 'Enter your mobile number',
                                labelText: 'Mobile Number',
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return 'Please enter a mobile number';
                                } else if (RegExp(r'[a-zA-Z,.-/#;*+()]')
                                    .hasMatch(value)) {
                                  return 'Enter a valid mobile number';
                                } else if (value.trim().length != 10) {
                                  return 'Mobile number should be a ten digit number';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              controller: _email,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                hintText: 'Enter your email address',
                                labelText: 'Email Address',
                              ),
                              validator: (val) {
                                if (val!.trim().isEmpty) {
                                  return 'Please provide an email address';
                                } else if (!RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val)) {
                                  return 'Please provide an valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            TextFormField(
                              controller: _licenseNumber,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                                hintText: 'Enter your shop license number',
                                labelText: 'License Number',
                              ),
                              validator: (val) {
                                if (val!.trim().length < 2) {
                                  return 'Enter a valid license number';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                            SizedBox(
                              width: 300,
                              child: showButton(
                                context: context,
                                text: 'SUBMIT',
                                onPressed: _addVendor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
