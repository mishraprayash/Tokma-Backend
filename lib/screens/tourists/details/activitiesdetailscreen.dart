import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/database/db_handler.dart';

class ActivitieDetailScreen extends StatefulWidget {
  final String id;

  ActivitieDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<ActivitieDetailScreen> createState() => _ActivitieDetailScreenState();
}

class _ActivitieDetailScreenState extends State<ActivitieDetailScreen> {
  bool _isLoading = true;
  String errorMessage = '';
  Map<String, dynamic> activityDetail = {};

  @override
  void initState() {
    super.initState();
    _fetchActivityDetail();
  }

  Future<void> _fetchActivityDetail() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      if (token != null) {
        var response = await http.post(
          Uri.parse(
              'https://tokma.onrender.com/api/activity/individual-service'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({'id': widget.id}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          setState(() {
            activityDetail = data['data'];
            _isLoading = false;
          });
        } else {
          print('Failed to load Activity Detail: ${response.body}');
          setState(() {
            _isLoading = false;
            errorMessage = 'Failed to load activity details';
          });
        }
      } else {
        print('No session found');
        setState(() {
          _isLoading = false;
          errorMessage = 'No session found';
        });
      }
    } catch (e) {
      print('Error fetching activity detail: $e');
      setState(() {
        _isLoading = false;
        errorMessage = 'Error fetching activity details';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activity"),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (activityDetail.containsKey('profileImg'))
                        Image.network(
                          activityDetail['profileImg'],
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset('assets/default.png');
                          },
                        ),
                      SizedBox(height: 20),
                      _buildProfileListTile(
                          icon: Icons.local_activity,
                          title: 'Name',
                          subtitle: activityDetail['name']),
                      _buildProfileListTile(
                          icon: Icons.description,
                          title: 'Description',
                          subtitle: activityDetail['description']),
                      _buildProfileListTile(
                          icon: Icons.phone,
                          title: 'Contact Number',
                          subtitle: activityDetail['contactNo']),
                      _buildProfileListTile(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: activityDetail['email']),
                      // Add more fields as needed
                    ],
                  ),
                ),
    );
  }

  Widget _buildProfileListTile({
    required IconData icon,
    required String title,
    required String? subtitle,
  }) {
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
