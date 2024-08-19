
import 'package:edu_vista_app/pages/onBoarding_page.dart';
import 'package:edu_vista_app/pages/home_page.dart';
import 'package:edu_vista_app/services/pref.service.dart';
import 'package:edu_vista_app/utils/images.utility.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  static String id = 'SplashPage';
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    _startApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
             ImagesUtility.logo,
            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  void _startApp() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      if (PreferencesService.isOnBoardingSeen) {
        Navigator.pushReplacementNamed(context, HomePage.id);
      } else {
        Navigator.pushReplacementNamed(context, OnBoardingPage.id);
      }
    }
  }
}
