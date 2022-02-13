import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../helpers/reusables_helper.dart';
import '../helpers/enum_helper.dart';
import '../providers/app_user_provider.dart';
import '../pages/login_otp_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginpage';

  const LoginPage({Key? key}) : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey();
  final TextEditingController _loginPhoneNumber = TextEditingController();
  bool _isLoading = false;

  Future<void> _checkAndLoginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final response =
          await Provider.of<AppUserProvider>(context, listen: false)
              .checkUser(_loginPhoneNumber.text);
      setState(() {
        _isLoading = false;
      });
      if (response == ProviderResponse.userDoesnotExist) {
        displaySnackBar(
          context: context,
          text: 'User with this mobile number does not exist. Please register!',
        );
      } else if (response == ProviderResponse.error) {
        displaySnackBar(
          context: context,
          text:
              'An unexpected error had occured, please check your internet connection or try again.',
        );
      } else if (response == ProviderResponse.userExists) {
        Navigator.of(context).pushReplacementNamed(LoginOtpPage.routeName);
      }
    }
  }

  @override
  void dispose() {
    _loginPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: _isLoading
          ? loader(context)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.21,
                      ),
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
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(35, 0, 40, 35),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              'Login',
                              style: GoogleFonts.openSans(
                                color: Theme.of(context).primaryColor,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Form(
                                key: _loginFormKey,
                                child: TextFormField(
                                  controller: _loginPhoneNumber,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(
                                        left: 20, right: 10, top: 10),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    labelText: 'Phone Number',
                                  ),
                                  validator: (value) {
                                    if (value!.trim().isEmpty) {
                                      return 'Please enter a Mobile Number';
                                    } else if (RegExp(r'[a-zA-Z,.-/#;*+()]')
                                        .hasMatch(value)) {
                                      return 'Enter a valid Mobile Number';
                                    } else if (value.length != 10) {
                                      return 'Mobile Number should be a ten digit number';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: showButton(
                                context: context,
                                onPressed: _checkAndLoginUser,
                                text: 'LOGIN',
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
