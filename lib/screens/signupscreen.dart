import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yatri/main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _userType = 'Tourist';
  final List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    // Initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(26.0, 80.0, 26.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ToggleButtons(
                isSelected: _isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int i = 0; i < _isSelected.length; i++) {
                      _isSelected[i] = i == index;
                    }
                    _userType = index == 0 ? 'Tourist' : 'Local Guide';
                  });
                },
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.0),
                    child: Text('Tourist'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.0),
                    child: Text('Local Guide'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (_userType == 'Tourist') _buildTouristSignUpForm(),
            if (_userType == 'Local Guide') _buildLocalGuideSignUpForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildTouristSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(
          height: mq.height * 0.015,
        ),
        ElevatedButton(
          onPressed: () {
            // Handle tourist sign-up
          },
          child: const Text('Sign Up as Tourist'),
        ),
        SizedBox(
          height: mq.height * 0.01,
        ),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Already account? ",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              TextSpan(
                text: "Login Here",
                style: const TextStyle(color: Color(0xFF1a6b9c), fontSize: 20),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/login');
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocalGuideSignUpForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(
          decoration: InputDecoration(
            labelText: 'Full Name',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Experience (in years)',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Areas of Expertise',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: mq.height * 0.015,
        ),
        ElevatedButton(
          onPressed: () {
            // Handle local guide sign-up
          },
          child: const Text('Sign Up as Local Guide'),
        ),
        SizedBox(
          height: mq.height * 0.01,
        ),
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: "Already account? ",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              TextSpan(
                text: "Login Here",
                style: const TextStyle(color: Color(0xFF1a6b9c), fontSize: 20),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, '/login');
                  },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
