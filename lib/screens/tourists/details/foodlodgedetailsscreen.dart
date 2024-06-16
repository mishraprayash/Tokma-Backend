import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/database/db_handler.dart';

class FoodLodgeDetailScreen extends StatefulWidget {
  final String id;

  FoodLodgeDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<FoodLodgeDetailScreen> createState() => _FoodLodgeDetailScreenState();
}

class _FoodLodgeDetailScreenState extends State<FoodLodgeDetailScreen> {
  bool _isLoading = true;
  String errorMessage = '';
  Map<String, dynamic> lodgeDetail = {};

  @override
  void initState() {
    super.initState();
    _fetchLodgeDetail();
  }

  @override
  void dispose() {
    super.dispose();
    // Clean up any ongoing operations
  }

  Future<void> _fetchLodgeDetail() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      if (token != null) {
        var response = await http.post(
          Uri.parse(
              'https://tokma.onrender.com/api/foodandlodge/individual-service'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({'id': widget.id}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            lodgeDetail = data['foodandlodging'];
            _isLoading = false;
          });
        } else {
          print('Failed to load Lodge Detail: ${response.body}');
          setState(() {
            _isLoading = false;
            errorMessage = 'Failed to load lodge details';
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
      print('Error fetching lodge detail: $e');
      setState(() {
        _isLoading = false;
        errorMessage = 'Error fetching lodge details';
      });
    }
  }

  Widget _buildProfileImage() {
    if (lodgeDetail.containsKey('profileImg') &&
        lodgeDetail['profileImg'].isNotEmpty) {
      return Image.network(
        lodgeDetail['profileImg'],
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset('assets/default.png');
        },
      );
    } else {
      return Image.asset(
        'assets/default.png',
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food & Lodge",
          style: TextStyle(color: Colors.white),
        ),
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
                      _buildProfileImage(),
                      SizedBox(height: 20),
                      _buildProfileListTile(
                        icon: Icons.local_hotel,
                        title: 'Name',
                        subtitle: lodgeDetail['name'],
                      ),
                      _buildProfileListTile(
                        icon: Icons.description,
                        title: 'Description',
                        subtitle: lodgeDetail['description'],
                      ),
                      _buildProfileListTile(
                        icon: Icons.phone,
                        title: 'Contact Number',
                        subtitle: lodgeDetail['contactNo'],
                      ),
                      _buildProfileListTile(
                        icon: Icons.email,
                        title: 'Email',
                        subtitle: lodgeDetail['email'],
                      ),
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
