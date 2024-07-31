import 'package:edu_vista_app/utils/images.utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: 
Image.asset(ImagesUtility.logo)
      
      ),
    );
  }
}