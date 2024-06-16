import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/database/db_handler.dart';
import 'package:yatri/main.dart';
import 'package:yatri/screens/tourists/details/localguidedetailsscreen.dart';

class HireGuideScreen extends StatefulWidget {
  const HireGuideScreen({super.key});

  @override
  State<HireGuideScreen> createState() => _HireGuideScreenState();
}

class _HireGuideScreenState extends State<HireGuideScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> nearbyGuides = [];
  List<Map<String, dynamic>> filteredGuides = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGuides();
    _searchController.addListener(_filterGuides);
  }

  Future<void> _fetchGuides() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      final response = await http.get(
        Uri.parse('https://tokma.onrender.com/api/tourist/nearby-guide'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          nearbyGuides = List<Map<String, dynamic>>.from(data['nearbyGuides']);
          filteredGuides =
              List<Map<String, dynamic>>.from(data['nearbyGuides']);
          _isLoading = false;
        });
      } else {
        print('Failed to load guides: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching guides: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterGuides() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredGuides = nearbyGuides.where((guide) {
        final name =
            (guide['firstName'] + ' ' + guide['lastName']).toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterGuides);
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
                  "Hire a Local Guide???",
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
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                "\"Hire a local guide and know about the place, experience its culture and tradition in a better way\".",
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
              "Guides available in your region",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredGuides.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredGuides.length,
                          itemBuilder: (context, index) {
                            final guide = filteredGuides[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LocalGuideDetailScreen(
                                            id: guide['_id']),
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
                                        child: const Icon(Icons.person,
                                            size: 30, color: Colors.grey),
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        "${guide['firstName']} ${guide['lastName']}",
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Age: ${guide['age']}",
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Gender: ${guide['gender']}",
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "Contact Number: ${guide['contactNo']}",
                                          style:
                                              const TextStyle(fontSize: 16.0),
                                        ),
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
                            'No guides found.',
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
