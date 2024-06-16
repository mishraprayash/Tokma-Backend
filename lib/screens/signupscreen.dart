import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yatri/main.dart';
import 'package:yatri/screens/local%20guide/signupscreenforlocalguide.dart';
import 'package:yatri/screens/tourists/screenonly/signupscreenfortourist.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 35),
            TextButton(
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                backgroundColor: const Color(0xFFA1662f),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreenForTourist(),
                  ),
                );
              },
              child: const Text(
                'Sign Up as Tourist',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                backgroundColor: const Color(0xFFA1662f),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpScreenForLocalGuide(),
                  ),
                );
              },
              child: const Text(
                'Sign Up as Local Guide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Already have an account? ",
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  TextSpan(
                    text: "Login Here",
                    style:
                        const TextStyle(color: Color(0xFFA1662f), fontSize: 16),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(context, '/login');
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
