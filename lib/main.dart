import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yatri/screens/emergencyscreen.dart';
import 'package:yatri/screens/foodandlodgescreen.dart';
import 'package:yatri/screens/healthservices.dart';
import 'package:yatri/screens/hireguidescreen.dart';
import 'package:yatri/screens/homescreenforlocalguide.dart';
import 'package:yatri/screens/homescreenfortourist.dart';
import 'package:yatri/screens/loginscreen.dart';
import 'package:yatri/screens/setting.dart';
import 'package:yatri/screens/signupscreen.dart';
import 'package:yatri/screens/splashscreen.dart';

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
        '/emergency': (context) => const EmergencyScreen(),
        '/hireguide': (context) => const HireGuideScreen(),
        '/login': (context) => const LoginScreen(),
        '/settings': (context) => const SettingScreen(),
        '/signup': (context) => const SignUpScreen(),
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
