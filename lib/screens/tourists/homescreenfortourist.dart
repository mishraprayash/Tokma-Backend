import 'package:flutter/material.dart';
import 'package:yatri/Widget/locationservices.dart';
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/main.dart';
import 'package:yatri/Model/guide.dart'; // Import your guide model
import 'package:yatri/screens/tourists/foodandlodgescreen.dart';
import 'package:yatri/screens/tourists/healthservices.dart';
import 'package:yatri/screens/tourists/localguidescreen.dart';
import 'package:yatri/screens/tourists/recommendedactivitiesscreen.dart';

// Mock data for demonstration (replace with actual data fetching logic)
final List<String> nearbyPlaces = ["Place 1", "Place 2", "Place 3"];
final List<String> nearbyHealthServices = [
  "Health Service 1",
  "Health Service 2",
  "Health Service 3"
];
final List<String> recommendedActivities = [
  "Activity 1",
  "Activity 2",
  "Activity 3"
];
final List<Guide> nearbyGuides = [
  Guide(name: "John Doe", age: 30, totalGuides: 5),
  Guide(name: "Jane Smith", age: 28, totalGuides: 3),
];

class HomeScreenForTourist extends StatefulWidget {
  const HomeScreenForTourist({super.key});

  @override
  State<HomeScreenForTourist> createState() => _HomeScreenForTouristState();
}

class _HomeScreenForTouristState extends State<HomeScreenForTourist> {
  // Initialize LocationServices instance
  LocationServices _locationServices = LocationServices();

  @override
  void initState() {
    super.initState();
    // Start listening for location updates
    _locationServices.getLocationUpdates();
  }

  @override
  void dispose() {
    // Stop listening for location updates when the widget is disposed
    _locationServices.stopListening();
    super.dispose();
  }

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Color.fromARGB(255, 173, 150, 128),
              padding: const EdgeInsets.all(7.0),
              child: const Text(
                "Travel Smart, Travel Safe",
                style: TextStyle(
                  fontSize: 24.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            buildSection(
              title: "Recommended Food & Lodge",
              items: nearbyPlaces,
              seeMoreCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodLodgeScreen(),
                  ),
                );
              },
            ),
            buildSection(
              title: "Nearby Health Services",
              items: nearbyHealthServices,
              seeMoreCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthServicesScreen(),
                  ),
                );
              },
            ),
            buildSection(
              title: "Recommended Activities",
              items: recommendedActivities,
              seeMoreCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecommendedActivitiesScreen(),
                  ),
                );
              },
            ),
            buildGuidesSection(
              title: "Nearby Local Guides",
              guides: nearbyGuides,
              seeMoreCallback: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HireGuideScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required List<String> items,
    required VoidCallback seeMoreCallback,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 100.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 150.0,
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(items[index]),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: seeMoreCallback,
              child: Text("See More"),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGuidesSection({
    required String title,
    required List<Guide> guides,
    required VoidCallback seeMoreCallback,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8.0),
          SizedBox(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: guides.length,
              itemBuilder: (context, index) {
                final guide = guides[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                    width: 150.0,
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[200],
                          child: const Icon(Icons.person, size: 30),
                        ),
                        const SizedBox(height: 8.0),
                        Text(guide.name),
                        Text("Age: ${guide.age}"),
                        Text("Guides: ${guide.totalGuides}"),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: seeMoreCallback,
              child: Text("See More"),
            ),
          ),
        ],
      ),
    );
  }
}
