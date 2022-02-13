import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/enum_helper.dart';
import '../helpers/reusables_helper.dart';
import '../providers/auth_provider.dart';
import '../providers/app_user_provider.dart';
import './maintenance_page.dart';
import './add_vendor_page.dart';
import './vendor_status_page.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/homepage';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    final appUserProvider =
        Provider.of<AppUserProvider>(context, listen: false);
    final appStatus = await appUserProvider.checkAppStatus();
    if (appStatus == ProviderResponse.underMaintainence) {
      Navigator.of(context).pushReplacementNamed(MaintenancePage.routeName);
    } else {
      if (_isInit) {
        setState(() {
          _isLoading = true;
        });
        if (appUserProvider.appUser == null) {
          final userResponse = await appUserProvider.getUser(
            Provider.of<AuthProvider>(context, listen: false)
                .user!
                .phoneNumber!
                .substring(3),
          );
          if (userResponse == ProviderResponse.error) {
            setState(() {
              _isLoading = false;
            });
            displaySnackBar(
              context: context,
              text:
                  'An unexpected error had occured while fetching user, please check your internet connection or try again.',
            );
          }
        }
        setState(() {
          _isLoading = false;
        });
      }
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(
        child: const Text("HUM Bazaar"),
      ),
      body: _isLoading
          ? loader(context)
          : Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Column(
                children: [],
              ),
            ),
      drawer: Drawer(
        child: Provider.of<AppUserProvider>(context, listen: false).appUser ==
                null
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'An unexpected error had occured while fetching user, please check your internet connection or try again.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            : ListView(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.025),
                  Text(
                    'Hello ${Provider.of<AppUserProvider>(context, listen: false).appUser!.name} !',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.home,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Home',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const Divider(color: Colors.white30),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.plus,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Add Vendor',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pushNamed(AddVendorPage.routeName);
                    },
                  ),
                  const Divider(color: Colors.white30),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.clipboard,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Vendor Status',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushNamed(VendorStatusPage.routeName);
                    },
                  ),
                  const Divider(color: Colors.white30),
                  ListTile(
                    leading: const Icon(
                      FontAwesomeIcons.signOutAlt,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Log out',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Provider.of<AuthProvider>(context, listen: false)
                          .signOut(context);
                    },
                  ),
                  const Divider(),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.006),
                  Center(
                    child: Text(
                      'Designed & Developed by GADS LLP',
                      style: GoogleFonts.openSans(color: Colors.white54),
                    ),
                  ),
                  Center(
                    child: Text(
                      'V 1.0.0',
                      style: GoogleFonts.openSans(color: Colors.white54),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
