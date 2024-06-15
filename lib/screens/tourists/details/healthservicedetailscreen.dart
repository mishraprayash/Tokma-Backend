import 'package:flutter/material.dart';

class HealthServiceDetailScreen extends StatefulWidget {
  const HealthServiceDetailScreen({super.key});

  @override
  State<HealthServiceDetailScreen> createState() =>
      _HealthServiceDetailScreenState();
}

class _HealthServiceDetailScreenState extends State<HealthServiceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Health Service"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
