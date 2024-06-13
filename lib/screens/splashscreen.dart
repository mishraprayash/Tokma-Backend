// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:yatri/database/db_handler.dart';
import 'package:yatri/main.dart';
import 'package:yatri/screens/homescreenfortourist.dart';
import 'package:yatri/screens/loginscreen.dart';

// This is the splash screen widget which appears when the app is launched
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      bool idRequested = await dbHelper.getIdRequestedState();

      if (idRequested) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreenForTourist()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: mq.height * .125,
              child: Transform.scale(
                scale: 1.5,
                child: Image.asset(
                  'assets/tokma.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "\"Travel Smart, Travel Safe\"",
              style: TextStyle(
                fontSize: 24.0,
                color: Color(0xFFA1662f),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
