import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/database/db_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _touristDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTouristDetails();
  }

  Future<void> _fetchTouristDetails() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();
      print("token: $token");

      if (token != null) {
        var response = await http.get(
          Uri.parse('https://tokma.onrender.com/api/tourist/tourist-info'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print("response: $response");

        if (response.statusCode == 200) {
          setState(() {
            Map<String, dynamic> responseData = jsonDecode(response.body);
            _touristDetails = responseData['touristDetails'];
            print("touristsdetails: $_touristDetails");
            _isLoading = false;
          });
        } else {
          print('Failed to load profile: ${response.body}');
        }
      } else {
        print('No session found');
      }
    } catch (e) {
      print('Error fetching tourist details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _touristDetails == null
              ? const Center(child: Text('Failed to load profile data'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                child: Icon(Icons.person, size: 50),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${_touristDetails!['firstName'] ?? 'N/A'} ${_touristDetails!['lastName'] ?? 'N/A'}',
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
                        _buildProfileListTile(
                            icon: Icons.person,
                            title: 'Name',
                            subtitle:
                                '${_touristDetails!['firstName'] ?? 'N/A'} ${_touristDetails!['lastName'] ?? 'N/A'}'),
                        _buildProfileListTile(
                            icon: Icons.email,
                            title: 'Email',
                            subtitle: _touristDetails!['email']),
                        _buildProfileListTile(
                            icon: Icons.phone,
                            title: 'Contact Number',
                            subtitle: _touristDetails!['contactNo']),
                        _buildProfileListTile(
                            icon: Icons.male,
                            title: 'Gender',
                            subtitle: _touristDetails!['gender']),
                        _buildProfileListTile(
                            icon: Icons.cake,
                            title: 'Age',
                            subtitle: _touristDetails!['age'].toString()),
                        _buildProfileListTile(
                            icon: Icons.flag,
                            title: 'Country',
                            subtitle: _touristDetails!['country']),
                        _buildProfileListTile(
                            icon: Icons.phone,
                            title: 'Emergency Contact Number',
                            subtitle: _touristDetails!['emergencyNumber']),
                        _buildProfileListTile(
                            icon: Icons.email,
                            title: 'Emergency Contact Email',
                            subtitle: _touristDetails!['emergencyEmail']),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildProfileListTile(
      {required IconData icon,
      required String title,
      required String? subtitle}) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle ?? 'N/A',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
