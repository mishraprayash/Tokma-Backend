import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/Model/hospital.dart';
import 'package:yatri/database/db_handler.dart';

class HealthServicesScreen extends StatefulWidget {
  const HealthServicesScreen({super.key});

  @override
  State<HealthServicesScreen> createState() => _HealthServicesScreenState();
}

class _HealthServicesScreenState extends State<HealthServicesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<HealthService> healthServices = [];
  List<HealthService> filteredHealthServices = [];
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
      print("token: $token");
      final response = await http.get(
        Uri.parse(
            'https://tokma.onrender.com/api/tourist/nearby-healthservice'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print("Response: $response");
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          healthServices =
              data.map((item) => HealthService.fromJson(item)).toList();
          filteredHealthServices = healthServices;
          _isLoading = false;
        });
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
        final name = service.name.toLowerCase();
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
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          "Health Services",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search health services...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Nearest Health Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredHealthServices.isNotEmpty
                      ? ListView.builder(
                          itemCount: filteredHealthServices.length,
                          itemBuilder: (context, index) {
                            final healthService = filteredHealthServices[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: healthService
                                          .profileImg.isNotEmpty
                                      ? NetworkImage(healthService.profileImg)
                                      : null,
                                  child: healthService.profileImg.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                title: Text(healthService.name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 5),
                                    Text('Contact: ${healthService.contactNo}'),
                                    const SizedBox(height: 5),
                                    Text(
                                        'Location: ${healthService.regionalLocation}'),
                                  ],
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
