import 'package:flutter/material.dart';
import 'package:yatri/database/db_handler.dart';
import 'package:yatri/main.dart';
import 'package:yatri/screens/homescreenfortourist.dart';
import 'package:yatri/screens/homescreenforlocalguide.dart';
import 'package:yatri/screens/loginscreen.dart';

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
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate a splash screen delay
    Map<String, dynamic> appState = await dbHelper.getAppState();

    if (appState['idRequested'] == 1) {
      String userType = appState['userType'];
      if (userType == 'Tourist') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreenForTourist(),
          ),
        );
      } else if (userType == 'Local Guide') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreenForLocalGuide(),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
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
            const Text(
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
