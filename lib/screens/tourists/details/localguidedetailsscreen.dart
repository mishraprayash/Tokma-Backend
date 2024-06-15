import 'package:flutter/material.dart';

class LocalGuideDetailScreen extends StatefulWidget {
  const LocalGuideDetailScreen({super.key});

  @override
  State<LocalGuideDetailScreen> createState() => _LocalGuideDetailScreenState();
}

class _LocalGuideDetailScreenState extends State<LocalGuideDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Guide"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
