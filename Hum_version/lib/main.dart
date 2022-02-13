import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import './providers/auth_provider.dart';
import './providers/app_user_provider.dart';
import './providers/vendor_provider.dart';
import './pages/login_page.dart';
import './pages/home_page.dart';
import './pages/login_otp_page.dart';
import './pages/maintenance_page.dart';
import './pages/add_vendor_page.dart';
import './pages/vendor_status_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

Map<int, Color> color = {
  50: const Color.fromRGBO(28, 30, 43, .1),
  100: const Color.fromRGBO(28, 30, 43, .2),
  200: const Color.fromRGBO(28, 30, 43, .3),
  300: const Color.fromRGBO(28, 30, 43, .4),
  400: const Color.fromRGBO(28, 30, 43, .5),
  500: const Color.fromRGBO(28, 30, 43, .6),
  600: const Color.fromRGBO(28, 30, 43, .7),
  700: const Color.fromRGBO(28, 30, 43, .8),
  800: const Color.fromRGBO(28, 30, 43, .9),
  900: const Color.fromRGBO(28, 30, 43, 1),
};

MaterialColor colorCustom = MaterialColor(0xFF1C1E2B, color);

class MyApp extends StatelessWidget {
  static const primaryColor = Color(0xFF1C1E2B);
  static const green = Color(0xFF037f00);
  static const yellow = Color(0xFFf19d1e);
  static const grey = Color(0xFF979698);
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
        ChangeNotifierProvider<AppUserProvider>(
            create: (_) => AppUserProvider()),
        ChangeNotifierProvider<VendorProvider>(create: (_) => VendorProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: colorCustom,
          primaryColor: colorCustom,
          buttonColor: green,
          accentColor: yellow,
          hintColor: grey,
          canvasColor: primaryColor,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: yellow,
            selectionHandleColor: yellow,
            selectionColor: yellow,
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          HomePage.routeName: (ctx) => const HomePage(),
          LoginPage.routeName: (ctx) => const LoginPage(),
          LoginOtpPage.routeName: (ctx) => const LoginOtpPage(),
          MaintenancePage.routeName: (ctx) => const MaintenancePage(),
          AddVendorPage.routeName: (ctx) => const AddVendorPage(),
          VendorStatusPage.routeName: (ctx)=> const VendorStatusPage(),
        },
        home: AuthProvider.handleAuth(),
      ),
    );
  }
}
