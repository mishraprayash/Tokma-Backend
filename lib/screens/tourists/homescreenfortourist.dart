import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/Widget/locationservices.dart';
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/database/db_handler.dart';
import 'package:yatri/main.dart';
import 'package:yatri/screens/tourists/details/activitiesdetailscreen.dart';
import 'package:yatri/screens/tourists/details/foodlodgedetailsscreen.dart';
import 'package:yatri/screens/tourists/details/healthservicedetailscreen.dart';
import 'package:yatri/screens/tourists/details/localguidedetailsscreen.dart';
import 'package:yatri/screens/tourists/foodandlodgescreen.dart';
import 'package:yatri/screens/tourists/healthservices.dart';
import 'package:yatri/screens/tourists/localguidescreen.dart';
import 'package:yatri/screens/tourists/recommendedactivitiesscreen.dart';

class HomeScreenForTourist extends StatefulWidget {
  const HomeScreenForTourist({super.key});

  @override
  State<HomeScreenForTourist> createState() => _HomeScreenForTouristState();
}

class _HomeScreenForTouristState extends State<HomeScreenForTourist> {
  final LocationServices _locationServices = LocationServices();
  TextEditingController _searchController = TextEditingController();

  List<String> nearbyPlaces = [];
  List<Map<String, dynamic>> nearbyHealthServices = [];
  List<String> recommendedActivities = [];
  List<Map<String, dynamic>> nearbyGuides = [];
  bool _isLoading = true;
  String errorMessage = '';

  List<dynamic> searchList = [];

  @override
  void initState() {
    super.initState();
    _locationServices.getLocationUpdates();
    _fetchTouristServices();
  }

  Future<void> _fetchTouristServices() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();
      print("Token: $token");

      if (token != null) {
        var response = await http.get(
          Uri.parse('https://tokma.onrender.com/api/tourist/services'),
          headers: {'Authorization': 'Bearer $token'},
        );
        String responseBody = response.body;
        print("Response status: ${response.statusCode}");
        print("Response body: $responseBody");

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          setState(() {
            nearbyGuides =
                List<Map<String, dynamic>>.from(data['nearbyGuides'] ?? []);
            nearbyHealthServices = List<Map<String, dynamic>>.from(
                data['nearbyHealthService'] ?? []);
            // Add your logic to fetch and map nearbyPlaces and recommendedActivities
            _isLoading = false;
          });
        } else {
          print('Failed to load Services: ${response.body}');
          setState(() {
            _isLoading = false;
            errorMessage = 'Failed to load services';
          });
        }
      } else {
        print('No session found');
        setState(() {
          _isLoading = false;
          errorMessage = 'No session found';
        });
      }
    } catch (e) {
      print('Error fetching tourist services: $e');
      setState(() {
        _isLoading = false;
        errorMessage = 'Error fetching services';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _searchController,
              onChanged: (value) {
                performSearch(value);
              },
              decoration: InputDecoration(
                hintText: 'Search services...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none),
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
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
                      if (searchList.isNotEmpty) ...[
                        buildSearchSection(searchList),
                        const SizedBox(height: 16.0),
                      ],
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
                        isHealthServiceSection: true,
                      ),
                      buildSection(
                        title: "Recommended Activities",
                        items: recommendedActivities,
                        seeMoreCallback: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecommendedActivitiesScreen(),
                            ),
                          );
                        },
                      ),
                      buildSection(
                        title: "Nearby Local Guides",
                        items: nearbyGuides,
                        seeMoreCallback: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HireGuideScreen(),
                            ),
                          );
                        },
                        isGuideSection: true,
                      ),
                    ],
                  ),
                ),
    );
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchList = [];
      });
      return;
    }

    List<dynamic> allItems = [];
    allItems.addAll(nearbyPlaces);
    allItems.addAll(nearbyHealthServices);
    allItems.addAll(recommendedActivities);
    allItems.addAll(nearbyGuides);

    List<dynamic> matchingItems = [];
    matchingItems.addAll(allItems.where((item) =>
        (item['name'] != null &&
            item['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) ||
        (item['firstName'] != null &&
            item['firstName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) ||
        (item['lastName'] != null &&
            item['lastName']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))));

    setState(() {
      searchList = matchingItems;
    });
  }

  Widget buildSection({
    required String title,
    required List<dynamic> items,
    required VoidCallback seeMoreCallback,
    bool isHealthServiceSection = false,
    bool isGuideSection = false,
    bool isActivities = false,
    bool isFoodlodge = false,
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
            height: 180.0, // Adjust the height as per your design
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (isHealthServiceSection) {
                      // Navigate to Health Service Detail Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HealthServiceDetailScreen(),
                        ),
                      );
                    } else if (isGuideSection) {
                      // Navigate to Local Guide Detail Screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LocalGuideDetailScreen(),
                        ),
                      );
                    } else if (isFoodlodge) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FoodLodgeDetailScreen(),
                        ),
                      );
                    } else if (isActivities) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivitieDetailScreen(),
                        ),
                      );
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      width: 140.0,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.1), // color of shadow
                            spreadRadius: 1, // spread radius
                            blurRadius: 1, // blur radius
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isHealthServiceSection)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                height:
                                    125.0, // Adjust the height as per your design
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        items[index]['profileImg'] ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          if (isGuideSection)
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              backgroundImage:
                                  items[index]['profileImg'] != null
                                      ? NetworkImage(items[index]['profileImg'])
                                      : null,
                              child: items[index]['profileImg'] == null
                                  ? Icon(Icons.person,
                                      size: 30, color: Colors.grey)
                                  : null,
                            ),
                          const SizedBox(height: 8.0),
                          Text(
                            isGuideSection
                                ? "${items[index]['firstName']} ${items[index]['lastName']}"
                                : items[index]['name'] ?? '',
                            style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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

  Widget buildSearchSection(List<dynamic> searchItems) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Search Results",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 180.0, // Adjust the height as per your design
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: searchItems.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  width: 140.0, // Adjust the width as per your design
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (searchItems[index]['profileImg'] != null &&
                          searchItems[index]['name'] != null)
                        Container(
                          width: double.infinity,
                          height: 120.0, // Adjust the height as per your design
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: NetworkImage(
                                  searchItems[index]['profileImg']),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              searchItems[index]['name'].toUpperCase(),
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                backgroundColor: Colors.black.withOpacity(0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      if (searchItems[index]['profileImg'] != null &&
                          searchItems[index]['firstName'] != null &&
                          searchItems[index]['lastName'] != null)
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              NetworkImage(searchItems[index]['profileImg']),
                        ),
                      const SizedBox(height: 8.0),
                      Text(
                        searchItems[index]['name'] != null
                            ? searchItems[index]['name']
                            : "${searchItems[index]['firstName']} ${searchItems[index]['lastName']}",
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
