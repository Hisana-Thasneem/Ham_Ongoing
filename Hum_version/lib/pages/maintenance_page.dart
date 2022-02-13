import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MaintenancePage extends StatelessWidget {
  static const routeName = '/maintainence';

  const MaintenancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'HUM Bazaar',
                  style: GoogleFonts.openSans(
                    color: Theme.of(context).primaryColor,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  'assets/Maintainence.jpg',
                  height: MediaQuery.of(context).size.height * 0.5,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Application is Under Maintainence. Please try again later!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.openSans(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
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
