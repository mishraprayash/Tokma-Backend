import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/database/db_handler.dart';
import 'package:yatri/main.dart';
import 'package:yatri/screens/tourists/details/activitiesdetailscreen.dart';

class RecommendedActivitiesScreen extends StatefulWidget {
  const RecommendedActivitiesScreen({super.key});

  @override
  State<RecommendedActivitiesScreen> createState() =>
      _RecommendedActivitiesScreenState();
}

class _RecommendedActivitiesScreenState
    extends State<RecommendedActivitiesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> activities = [];
  List<Map<String, dynamic>> filteredActivities = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchActivities();
    _searchController.addListener(_filterActivities);
  }

  Future<void> _fetchActivities() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      final response = await http.get(
        Uri.parse(
            'https://tokma.onrender.com/api/tourist/recommended-activities'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          activities = data.cast<Map<String, dynamic>>();
          filteredActivities = activities;
          _isLoading = false;
        });
      } else {
        print('Failed to load activities: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching activities: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterActivities() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredActivities = activities.where((activity) {
        final name = activity['name']?.toString().toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterActivities);
    _searchController.dispose();
    super.dispose();
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
              decoration: InputDecoration(
                hintText: 'Search Activities...',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color.fromARGB(255, 126, 46, 46), Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  "Recommended Activities",
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 54),
              child: Text(
                "\"Discover exciting activities to do around you.\"",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const Divider(color: Colors.black45),
            const SizedBox(height: 10.0),
            const Text(
              "Activities recommended for you",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredActivities.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredActivities.length,
                          itemBuilder: (context, index) {
                            final activity = filteredActivities[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ActivitieDetailScreen(
                                        id: activity['_id']),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey[300],
                                        backgroundImage:
                                            activity['profileImg'] != null
                                                ? NetworkImage(
                                                    activity['profileImg'])
                                                : null,
                                        child: activity['profileImg'] == null
                                            ? const Icon(Icons.person,
                                                size: 30, color: Colors.grey)
                                            : null,
                                      ),
                                      const SizedBox(height: 8.0),
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: const Text("Join Now"),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text("Name: ${activity['name']}",
                                            style: const TextStyle(
                                                fontSize: 16.0)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Contact: ${activity['contactNo']}",
                                            style: const TextStyle(
                                                fontSize: 16.0)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Location: ${activity['regionalLocation']}",
                                            style: const TextStyle(
                                                fontSize: 16.0)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No activities found.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
