import 'dart:ui';

import 'package:edu_vista_app/blocs/course/course_bloc.dart';
import 'package:edu_vista_app/blocs/lecture/lecture_bloc.dart';
import 'package:edu_vista_app/cubit/auth_cubit.dart';
import 'package:edu_vista_app/firebase_options.dart';
import 'package:edu_vista_app/pages/all_categories.dart';
import 'package:edu_vista_app/pages/all_courses.dart';
import 'package:edu_vista_app/pages/course_details_page.dart';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  // await dotenv.load(fileName: ".env");

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (ctx) => AuthCubit()),
      BlocProvider(create: (ctx) => CourseBloc()),
      BlocProvider(create: (ctx) => LectureBloc()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: _CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: ColorUtility.scaffoldBackground,
        fontFamily: ' PlusJakartaSans',
        colorScheme: ColorScheme.fromSeed(seedColor: ColorUtility.main),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        final String routeName = settings.name ?? '';
        final dynamic data = settings.arguments;
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
           case AllCourses.id:
            return MaterialPageRoute(builder: (context) => AllCourses(category_id: data,  ));
            case AllCategories.id:
              return MaterialPageRoute(builder: (context) => const AllCategories());
          case CourseDetailsPage.id:
            return MaterialPageRoute(
                builder: (context) => CourseDetailsPage(
                      course: data,
                    ));

          default:
            return MaterialPageRoute(builder: (context) => const SplashPage());
        }
      },
      initialRoute: SplashPage.id,
    );
  }
}

class _CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
      };
}
