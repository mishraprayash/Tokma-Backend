import 'package:flutter/material.dart';

class FoodLodgeDetailScreen extends StatefulWidget {
  const FoodLodgeDetailScreen({super.key});

  @override
  State<FoodLodgeDetailScreen> createState() => _FoodLodgeDetailScreenState();
}

class _FoodLodgeDetailScreenState extends State<FoodLodgeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Food & Lodge"),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
    );
  }
}
