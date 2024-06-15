import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/database/db_handler.dart';

class HomeScreenForLocalGuide extends StatefulWidget {
  const HomeScreenForLocalGuide({super.key});

  @override
  State<HomeScreenForLocalGuide> createState() =>
      _HomeScreenForLocalGuideState();
}

class _HomeScreenForLocalGuideState extends State<HomeScreenForLocalGuide> {
  Map<String, dynamic>? _localGuideDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLocalGuideDetails();
  }

  Future<void> _fetchLocalGuideDetails() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      if (token != null) {
        var response = await http.get(
          Uri.parse('https://tokma.onrender.com/api/guide/dashboard'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          setState(() {
            _localGuideDetails = jsonDecode(response.body)['guide'];
            _isLoading = false;
          });
        } else {
          print('Failed to load profile: ${response.body}');
        }
      } else {
        print('No session found');
      }
    } catch (e) {
      print('Error fetching local guide details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: const Text(
          'Home Screen',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _localGuideDetails == null
              ? const Center(child: Text('Failed to load profile data'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person,
                                  size: 50), // Placeholder icon
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${_localGuideDetails!['firstName'] ?? 'N/A'} ${_localGuideDetails!['lastName'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Profile Information:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildProfileDetail('Name',
                          '${_localGuideDetails!['firstName']} ${_localGuideDetails!['lastName']}'),
                      _buildProfileDetail(
                          'Email', _localGuideDetails!['email']),
                      _buildProfileDetail(
                          'Contact Number', _localGuideDetails!['contactNo']),
                      _buildProfileDetail(
                          'Gender', _localGuideDetails!['gender']),
                      _buildProfileDetail(
                          'Age', _localGuideDetails!['age'].toString()),
                      _buildProfileDetail(
                          'Location', _localGuideDetails!['location']),
                      _buildProfileDetail(
                          'Description', _localGuideDetails!['description']),
                      const Spacer(),
                      const Text(
                        'Availability:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Local Time: ${DateTime.now().toString().substring(11, 16)}'),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: _handleLogout,
                          child: const Text('Logout'),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    await dbHelper.clearSession();
    Navigator.pushNamed(context, '/login');
  }
}
