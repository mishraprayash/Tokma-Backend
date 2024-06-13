import 'package:flutter/material.dart';
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/main.dart';

class HomeScreenForTourist extends StatefulWidget {
  const HomeScreenForTourist({super.key});

  @override
  State<HomeScreenForTourist> createState() => _HomeScreenForTouristState();
}

class _HomeScreenForTouristState extends State<HomeScreenForTourist> {
  @override
  Widget build(BuildContext context) {
    // Initializing media query for getting device screen size
    mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: mq.width * .02,
          ),
          SizedBox(
            width: mq.width * 0.86,
            height: mq.height * 0.05,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search services...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                suffixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            width: mq.width * .02,
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const Drawer(
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide.none),
        child: SideMenuList(),
      ),
      body: Column(
        children: [
          const SizedBox(
              height: 16.0), // Add space between AppBar and Container
          Container(
            width: double.infinity,
            color: Colors.lightBlue[100],
            padding: const EdgeInsets.all(7.0),
            child: const Text(
              "\"Travel Smart, Travel Safe\"",
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
