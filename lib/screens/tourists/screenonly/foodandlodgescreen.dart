import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/database/db_handler.dart';
import 'package:yatri/screens/tourists/details/foodlodgedetailsscreen.dart';

class FoodLodgeScreen extends StatefulWidget {
  const FoodLodgeScreen({super.key});

  @override
  State<FoodLodgeScreen> createState() => _FoodLodgeScreenState();
}

class _FoodLodgeScreenState extends State<FoodLodgeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> foodAndLodges = [];
  List<Map<String, dynamic>> filteredFoodAndLodges = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFoodAndLodges();
    _searchController.addListener(_filterFoodAndLodges);
  }

  Future<void> _fetchFoodAndLodges() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      final response = await http.get(
        Uri.parse('https://tokma.onrender.com/api/tourist/nearby-foodandlodge'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (mounted) {
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          setState(() {
            foodAndLodges =
                data['nearbyfoodandlodge'].cast<Map<String, dynamic>>();
            filteredFoodAndLodges = foodAndLodges;
            _isLoading = false;
          });
        } else {
          print('Failed to load food and lodges: ${response.body}');
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        print('Error fetching food and lodges: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterFoodAndLodges() {
    final query = _searchController.text.toLowerCase();
    if (mounted) {
      setState(() {
        filteredFoodAndLodges = foodAndLodges.where((foodLodge) {
          final name = foodLodge['name'].toLowerCase();
          return name.contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFoodAndLodges);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
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
                hintText: 'Search Food & Lodge...',
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
                  "Find Food & Lodge",
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
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 32),
              child: Text(
                "\"Discover the best places to eat and stay in your area.\"",
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
              "Food & Lodging available in your region",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredFoodAndLodges.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredFoodAndLodges.length,
                          itemBuilder: (context, index) {
                            final foodLodge = filteredFoodAndLodges[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FoodLodgeDetailScreen(
                                        id: foodLodge['_id']),
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
                                            foodLodge['profileImg'] != null
                                                ? NetworkImage(
                                                    foodLodge['profileImg'])
                                                : null,
                                        child: foodLodge['profileImg'] == null
                                            ? const Icon(Icons.person,
                                                size: 30, color: Colors.grey)
                                            : null,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Name: ${foodLodge['name']}",
                                            style: const TextStyle(
                                                fontSize: 16.0)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Description: ${foodLodge['description']}",
                                            style: const TextStyle(
                                                fontSize: 16.0)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Location: ${foodLodge['regionalLocation']}",
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
                            'No food and lodges found.',
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
