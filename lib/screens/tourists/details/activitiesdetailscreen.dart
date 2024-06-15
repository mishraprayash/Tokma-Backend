import 'package:flutter/material.dart';

class ActivitieDetailScreen extends StatefulWidget {
  const ActivitieDetailScreen({super.key});

  @override
  State<ActivitieDetailScreen> createState() => _ActivitieDetailScreenState();
}

class _ActivitieDetailScreenState extends State<ActivitieDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
