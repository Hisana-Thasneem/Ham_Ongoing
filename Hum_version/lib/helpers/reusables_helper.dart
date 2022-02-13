import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget loader(BuildContext context) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Theme.of(context).accentColor,
      ),
    ),
  );
}

AppBar appbar({required Widget child, bool showCart = true}) {
  return AppBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    title: child,
    centerTitle: true,
    actions: showCart
        ? [
            Padding(
              padding: const EdgeInsets.only(
                right: 15,
              ),
              child: Container(),
            ),
          ]
        : null,
  );
}

void displaySnackBar({required String text, BuildContext? context}) {
  ScaffoldMessenger.of(context!).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: Colors.white,
      margin: const EdgeInsets.all(15),
      elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      content: Text(
        text,
        style: GoogleFonts.openSans(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.w400),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
    ),
  );
}

void alert(
    {required BuildContext context,
    required String title,
    required String content,
    bool closePage = false}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx1) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        showButton(
            context: context,
            onPressed: () {
              Navigator.of(ctx1).pop();
              if (closePage) {
                Navigator.of(context).pop();
              }
            },
            text: 'OKAY')
      ],
    ),
  );
}

Widget showButton(
    {required String text,
    required void Function() onPressed,
    required BuildContext context}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: Theme.of(context).primaryColor,
      onPrimary: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: GoogleFonts.openSans(fontWeight: FontWeight.w600, fontSize: 15),
    ),
  );
}
