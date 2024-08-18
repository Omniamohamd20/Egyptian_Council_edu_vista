import 'dart:ui';

import 'package:edu_vista_app/pages/%E2%80%8EOnBoardingPage.dart';
import 'package:edu_vista_app/pages/splash_page.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  scrollBehavior: _CustomScrollBehaviour(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'PlusJakartaSans',
        scaffoldBackgroundColor: ColorUtility.scaffoldBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
        useMaterial3: true,
      ),
   onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';
        final Map? data = settings.arguments as Map?;
        switch (routeName) {
          // case LoginPage.id:
          //   return MaterialPageRoute(builder: (context) => LoginPage());
          // case SignUpPage.id:
          //   return MaterialPageRoute(builder: (context) => SignUpPage());
          // case ResetPasswordPage.id:
          //   return MaterialPageRoute(builder: (context) => ResetPasswordPage());
          case OnBoardingPage.id:
            return MaterialPageRoute(builder: (context) => OnBoardingPage());
          // case HomePage.id:
          //   return MaterialPageRoute(builder: (context) => HomePage());

          default:
            return MaterialPageRoute(builder: (context) => SplashPage());
        }
      },
         initialRoute: SplashPage.id,
    );
  }
}
class _CustomScrollBehaviour extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
