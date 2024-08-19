import 'dart:ui';

import 'package:edu_vista_app/cubit/auth_cubit.dart';
import 'package:edu_vista_app/firebase_options.dart';
import 'package:edu_vista_app/pages/home_page.dart';
import 'package:edu_vista_app/pages/login_page.dart';
import 'package:edu_vista_app/pages/onboarding_Page.dart';
import 'package:edu_vista_app/pages/reset_password_page.dart';
import 'package:edu_vista_app/pages/signup_page.dart';
import 'package:edu_vista_app/pages/splash_page.dart';
import 'package:edu_vista_app/services/pref.service.dart';
import 'package:edu_vista_app/utils/color.utility.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Failed to initialize Firebase: $e');
  }
  runApp(MultiBlocProvider(
    providers: [BlocProvider(create: (ctx) => AuthCubit())],
    child: const MyApp(),
  ));
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
        scaffoldBackgroundColor: ColorUtility.gry,
        fontFamily: ' PlusJakartaSans',
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';
        final Map? data = settings.arguments as Map?;
        switch (routeName) {
          case LoginPage.id:
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case SignUpPage.id:
            return MaterialPageRoute(builder: (context) => const SignUpPage());
          case ResetPasswordPage.id:
            return MaterialPageRoute(builder: (context) => const ResetPasswordPage());
          case OnBoardingPage.id:
            return MaterialPageRoute(builder: (context) => const OnBoardingPage());
          case HomePage.id:
            return MaterialPageRoute(builder: (context) => const HomePage());

          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
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
