import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _userType = 'Tourist';

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 80, left: 16, right: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Icon(
                  Icons.supervised_user_circle_outlined,
                  size: 120,
                  color: Color(0xFFA1662f),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: _userType,
                  onChanged: (String? newValue) {
                    setState(() {
                      _userType = newValue!;
                    });
                  },
                  items: <String>['Tourist', 'Local Guide']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: InputDecoration(
                    labelText: 'User Type',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _handleLogin();
                    }
                  },
                  child: Text('Login as $_userType'),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: mq.height * 0.055),
                  child: RichText(
                      text: TextSpan(children: [
                    const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    TextSpan(
                      text: "Sign Up Here",
                      style: const TextStyle(
                        color: Color(0xFFA1662f),
                        fontSize: 16,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, '/signup');
                        },
                    ),
                  ])),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() async {
    String url = _userType == 'Tourist'
        ? 'https://tokma.onrender.com/api/tourist/login'
        : 'https://tokma.onrender.com/api/guide/login';

    Map<String, String> credentials = {
      'email': _emailController.text,
      'password': _passwordController.text,
    };

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(credentials),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context,
            _userType == 'Tourist' ? '/homefortourist' : '/homeforlocalguide');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed: ${response.body}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
