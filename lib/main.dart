import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yatri/screens/tourists/foodandlodgescreen.dart';
import 'package:yatri/screens/tourists/healthservices.dart';
import 'package:yatri/screens/tourists/localguidescreen.dart';
import 'package:yatri/screens/local%20guide/homescreenforlocalguide.dart';
import 'package:yatri/screens/tourists/homescreenfortourist.dart';
import 'package:yatri/screens/loginscreen.dart';
import 'package:yatri/screens/tourists/profile.dart';
import 'package:yatri/screens/signupscreen.dart';
import 'package:yatri/screens/splashscreen.dart';
import 'package:yatri/screens/tourists/recommendedactivitiesscreen.dart';
import 'package:yatri/screens/tourists/rulebookscreen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white),
  );
  runApp(const MyApp());
}

late Size mq;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/homefortourist': (context) => const HomeScreenForTourist(),
        '/homeforlocalguide': (context) => const HomeScreenForLocalGuide(),
        '/foodlodge': (context) => const FoodLodgeScreen(),
        '/activities': (context) => const RecommendedActivitiesScreen(),
        '/localguide': (context) => const HireGuideScreen(),
        '/login': (context) => const LoginScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/rulebook': (context) => const RuleBookScreen(),
        '/healthservices': (context) => const HealthServicesScreen(),
      },
      title: 'Tokma',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFA1662f),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA1662f),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
