import 'package:flutter/material.dart';
import 'package:yatri/Model/guide.dart';
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/main.dart';

// Mock data (replace this with actual backend data fetching logic)
final List<Guide> guides = [
  Guide(name: "John Doe", age: 30, totalGuides: 5),
  Guide(name: "Jane Smith", age: 28, totalGuides: 3),
  Guide(name: "Mike Johnson", age: 35, totalGuides: 7),
  Guide(name: "Emily Davis", age: 25, totalGuides: 4),
];

class HireGuideScreen extends StatefulWidget {
  const HireGuideScreen({super.key});

  @override
  State<HireGuideScreen> createState() => _HireGuideScreenState();
}

class _HireGuideScreenState extends State<HireGuideScreen> {
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
            width: mq.width * 0.80,
            height: mq.height * 0.05,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Local Guide...',
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
          const Icon(Icons.home),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const Drawer(
        elevation: 0,
        shape: RoundedRectangleBorder(side: BorderSide.none),
        child: SideMenuList(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30.0), // Rounded corners
              ),
              padding: const EdgeInsets.all(16.0),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color.fromARGB(255, 126, 46, 46), Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "Hire a Local Guide???",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors
                        .white, // This color will be ignored due to ShaderMask
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                "\"Hire a local guide and know about the place, experience its culture and tradition in a better way\".",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic, // Make text italic
                ),
              ),
            ),
            const Divider(color: Colors.black45),
            const SizedBox(height: 10.0),
            const Text(
              "Guides available in your region",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            // Use GridView for displaying guides in rows of two
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 0.75,
                ),
                itemCount: guides.length,
                itemBuilder: (context, index) {
                  final guide = guides[index];
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.person,
                              size: 30, color: Colors.grey),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Hire Me"),
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Name: ${guide.name}",
                              style: const TextStyle(fontSize: 16.0)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Age: ${guide.age}",
                              style: const TextStyle(fontSize: 16.0)),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Total Guides: ${guide.totalGuides}",
                              style: const TextStyle(fontSize: 16.0)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
