import 'package:flutter/material.dart';

class HealthServicesScreen extends StatefulWidget {
  const HealthServicesScreen({super.key});

  @override
  State<HealthServicesScreen> createState() => _HealthServicesScreenState();
}

class _HealthServicesScreenState extends State<HealthServicesScreen> {
  String userName = "John Doe"; // This should be fetched from login details
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, String>> hospitals = [
    {
      'name': 'Gandaki Hospital',
      'address': 'Nayabazar, Pokhara',
      'phone': '041-456-7890',
      'image': 'assets/hospital1.jpg', // Add appropriate image assets
    },
    {
      'name': 'Fishtail Hospital',
      'address': 'Mahendrapool',
      'phone': '987-654-3210',
      'image': 'assets/hospital2.jpg',
    },
    // Add more hospitals as needed
  ];

  List<Map<String, String>> filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    filteredHospitals = hospitals; // Initialize with all hospitals
    _searchController.addListener(_filterHospitals);
  }

  void _filterHospitals() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredHospitals = hospitals.where((hospital) {
        final name = hospital['name']!.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterHospitals);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
                // backgroundImage:
                //     AssetImage('assets/profile.jpg'), // Add profile image asset
                ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                userName,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
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
                hintText: 'Search medicals...',
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
              child: filteredHospitals.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredHospitals.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: Image.asset(
                              filteredHospitals[index]['image']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(filteredHospitals[index]['name']!),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(
                                    'Address: ${filteredHospitals[index]['address']!}'),
                                const SizedBox(height: 5),
                                Text(
                                    'Phone No: ${filteredHospitals[index]['phone']!}'),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No hospitals found.',
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
