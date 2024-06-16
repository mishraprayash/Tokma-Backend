import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/Widget/locationservices.dart';
import 'package:yatri/database/db_handler.dart';

class HomeScreenForLocalGuide extends StatefulWidget {
  const HomeScreenForLocalGuide({Key? key}) : super(key: key);

  @override
  _HomeScreenForLocalGuideState createState() =>
      _HomeScreenForLocalGuideState();
}

class _HomeScreenForLocalGuideState extends State<HomeScreenForLocalGuide> {
  Map<String, dynamic>? _localGuideDetails;
  bool _isLoading = true;
  bool _isAvailable = false;
  // Initialize LocationServices instance
  LocationServices _locationServices = LocationServices();

  @override
  void initState() {
    super.initState();
    _fetchLocalGuideDetails();
  }

  Future<void> _fetchLocalGuideDetails() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getGuideSession();

      if (token != null) {
        var response = await http.get(
          Uri.parse('https://tokma.onrender.com/api/guide/dashboard'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (response.statusCode == 200) {
          setState(() {
            _localGuideDetails = jsonDecode(response.body)['guide'];
            _isAvailable = _localGuideDetails!['isAvailable'];
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

  void _logout() async {
    // Clear app state (login status) from SQLite database
    await DatabaseHelper().updateState(false, '');

    // Navigate to the login screen and remove all other routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Guide Profile',
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _localGuideDetails == null
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
                        _buildProfileListTile(
                            icon: Icons.person,
                            title: 'Name',
                            subtitle:
                                '${_localGuideDetails!['firstName']} ${_localGuideDetails!['lastName']}'),
                        _buildProfileListTile(
                            icon: Icons.email,
                            title: 'Email',
                            subtitle: _localGuideDetails!['email']),
                        _buildProfileListTile(
                            icon: Icons.phone,
                            title: 'Contact Number',
                            subtitle: _localGuideDetails!['contactNo']),
                        _buildProfileListTile(
                            icon: Icons.male,
                            title: 'Gender',
                            subtitle: _localGuideDetails!['gender']),
                        _buildProfileListTile(
                            icon: Icons.cake,
                            title: 'Age',
                            subtitle: _localGuideDetails!['age'].toString()),
                        _buildProfileListTile(
                            icon: Icons.location_on,
                            title: 'Location',
                            subtitle: _localGuideDetails!['regionalLocation']),
                        _buildProfileListTile(
                            icon: Icons.description,
                            title: 'Description',
                            subtitle: _localGuideDetails!['description']),
                        const SizedBox(height: 20),
                        const Text(
                          'Availability:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_isAvailable ? 'Available' : 'Not Available',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      _isAvailable ? Colors.green : Colors.grey,
                                )),
                            Switch(
                              value: _isAvailable,
                              onChanged: (newValue) {
                                setState(() {
                                  _isAvailable = newValue;
                                });
                                _locationServices.guideLocationUpdates();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: _logout,
                            child: const Text('Logout'),
                          ),
                        ),
                        const SizedBox(height: 16),
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
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle ?? 'N/A',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
