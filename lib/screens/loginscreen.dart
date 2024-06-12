import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yatri/main.dart';
import 'package:yatri/screens/homescreen.dart';

TextStyle mystyle = const TextStyle(fontSize: 25);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    // Initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    final emailfield = TextField(
      onChanged: (val) {
        setState(() {
          email = val;
        });
      },
      style: mystyle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
    final passwordfield = TextField(
      onChanged: (val) {
        setState(() {
          password = val;
        });
      },
      obscureText: true,
      style: mystyle,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        hintText: "Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
      ),
    );
    final myLoginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xFF1a6b9c),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        onPressed: () {
          if (email == "nilu@gmail.com" && password == "ilu") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          } else {
            print("Login Failed");
          }
        },
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      const Icon(
                        Icons.supervised_user_circle_outlined,
                        size: 120,
                        color: Color(0xFF1a6b9c),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      emailfield,
                      const SizedBox(
                        height: 20,
                      ),
                      passwordfield,
                      const SizedBox(
                        height: 20,
                      ),
                      myLoginButton,
                      SizedBox(
                        height: mq.height * 0.025,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: "Don't have account? ",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                            TextSpan(
                              text: "Sign Up Here",
                              style: const TextStyle(
                                  color: Color(0xFF1a6b9c), fontSize: 20),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/signup');
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
