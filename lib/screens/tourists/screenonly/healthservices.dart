import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/Widget/sidemenulist.dart';
import 'package:yatri/database/db_handler.dart';
import 'package:yatri/main.dart';
import 'package:yatri/screens/tourists/details/healthservicedetailscreen.dart';

class HealthServicesScreen extends StatefulWidget {
  const HealthServicesScreen({super.key});

  @override
  State<HealthServicesScreen> createState() => _HealthServicesScreenState();
}

class _HealthServicesScreenState extends State<HealthServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> healthServices = [];
  List<Map<String, dynamic>> filteredHealthServices = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHealthServices();
    _searchController.addListener(_filterHealthServices);
  }

  Future<void> _fetchHealthServices() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      final response = await http.get(
        Uri.parse(
            'https://tokma.onrender.com/api/tourist/nearby-healthservice'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['locations'] != null) {
          setState(() {
            healthServices = List<Map<String, dynamic>>.from(data['locations']);
            filteredHealthServices = healthServices;
            _isLoading = false;
          });
        } else {
          print('No health services found in the response.');
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        print('Failed to load health services: ${response.body}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching health services: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterHealthServices() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredHealthServices = healthServices.where((service) {
        final name = service['name']?.toString().toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterHealthServices);
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
                hintText: 'Search Health Services...',
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
                  "Find Health Services",
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
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
              child: Text(
                "\"Discover the best health services in your area.\"",
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
              "Health Services available in your region",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredHealthServices.isNotEmpty
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16.0,
                            crossAxisSpacing: 16.0,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: filteredHealthServices.length,
                          itemBuilder: (context, index) {
                            final healthService = filteredHealthServices[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HealthServiceDetailScreen(
                                            id: healthService['_id']),
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
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          width: double.infinity,
                                          height:
                                              120.0, // Adjust the height as per your design
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            image: DecorationImage(
                                              image: healthService[
                                                              'profileImg'] !=
                                                          null &&
                                                      healthService[
                                                              'profileImg']
                                                          .isNotEmpty
                                                  ? NetworkImage(healthService[
                                                      'profileImg'])
                                                  : AssetImage(
                                                          'assets/default.png')
                                                      as ImageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text("${healthService['name']}",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w600)),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Contact: ${healthService['contactNo']}",
                                            style: const TextStyle(
                                                fontSize: 16.0)),
                                      ),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                            "Location: ${healthService['regionalLocation']}",
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
                            'No health services found.',
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
