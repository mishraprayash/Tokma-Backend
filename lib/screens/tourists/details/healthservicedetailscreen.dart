import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/database/db_handler.dart';

class HealthServiceDetailScreen extends StatefulWidget {
  final String id;

  HealthServiceDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<HealthServiceDetailScreen> createState() =>
      _HealthServiceDetailScreenState();
}

class _HealthServiceDetailScreenState extends State<HealthServiceDetailScreen> {
  bool _isLoading = true;
  String errorMessage = '';
  Map<String, dynamic> healthServiceDetail = {};

  @override
  void initState() {
    super.initState();
    _fetchHealthServiceDetail();
  }

  @override
  void dispose() {
    super.dispose();
    // Ensure all async operations are canceled or completed before disposing
  }

  Future<void> _fetchHealthServiceDetail() async {
    if (widget.id.isEmpty) {
      setState(() {
        _isLoading = false;
        errorMessage = 'Invalid service ID';
      });
      return;
    }

    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      if (token != null) {
        var response = await http.post(
          Uri.parse(
              'https://tokma.onrender.com/api/healthservice/individual-service'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({'id': widget.id}),
        );

        // Check if the widget is still mounted before updating state
        if (mounted) {
          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            setState(() {
              healthServiceDetail = data['healthservice'];
              _isLoading = false;
            });
          } else {
            print('Failed to load Service Detail: ${response.body}');
            setState(() {
              _isLoading = false;
              errorMessage = 'Failed to load services';
            });
          }
        }
      } else {
        if (mounted) {
          print('No session found');
          setState(() {
            _isLoading = false;
            errorMessage = 'No session found';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        print('Error fetching health service detail: $e');
        setState(() {
          _isLoading = false;
          errorMessage = 'Error fetching service detail';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          "Health Service",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (healthServiceDetail.containsKey('profileImg') &&
                          healthServiceDetail['profileImg'].isNotEmpty)
                        Image.network(
                          healthServiceDetail['profileImg'],
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                                'assets/default.png'); // Fallback image
                          },
                        )
                      else
                        Image.asset('assets/default.png',
                            height: 200, fit: BoxFit.cover), // Fallback image
                      const SizedBox(height: 20),
                      _buildProfileListTile(
                          icon: Icons.local_hospital,
                          title: 'Name',
                          subtitle: healthServiceDetail['name']),
                      _buildProfileListTile(
                          icon: Icons.description,
                          title: 'Description',
                          subtitle: healthServiceDetail['description']),
                      _buildProfileListTile(
                          icon: Icons.phone,
                          title: 'Contact Number',
                          subtitle: healthServiceDetail['contactNo']),
                      _buildProfileListTile(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: healthServiceDetail['email']),
                      _buildProfileListTile(
                          icon: Icons.location_city_sharp,
                          title: 'Location',
                          subtitle: healthServiceDetail['regionalLocation']),
                      // Add more fields as needed
                    ],
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
      title: SelectableText(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: SelectableText(
        subtitle ?? 'N/A',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
