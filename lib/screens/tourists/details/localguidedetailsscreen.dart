import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/database/db_handler.dart';

class LocalGuideDetailScreen extends StatefulWidget {
  final String id;

  LocalGuideDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<LocalGuideDetailScreen> createState() => _LocalGuideDetailScreenState();
}

class _LocalGuideDetailScreenState extends State<LocalGuideDetailScreen> {
  bool _isLoading = true;
  String errorMessage = '';
  Map<String, dynamic> guideDetail = {};

  @override
  void initState() {
    super.initState();
    _fetchGuideDetail();
  }

  Future<void> _fetchGuideDetail() async {
    try {
      DatabaseHelper dbHelper = DatabaseHelper();
      String? token = await dbHelper.getSession();

      if (token != null) {
        var response = await http.post(
          Uri.parse('https://tokma.onrender.com/api/guide/individual-service'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode({'id': widget.id}),
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (mounted) {
            setState(() {
              guideDetail = data['guide'];
              _isLoading = false;
            });
          }
        } else {
          print('Failed to load Guide Detail: ${response.body}');
          if (mounted) {
            setState(() {
              _isLoading = false;
              errorMessage = 'Failed to load guide details';
            });
          }
        }
      } else {
        print('No session found');
        if (mounted) {
          setState(() {
            _isLoading = false;
            errorMessage = 'No session found';
          });
        }
      }
    } catch (e) {
      print('Error fetching guide detail: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          errorMessage = 'Error fetching guide details';
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: const Text(
          'Local Guide',
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
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.grey[300],
                              child: guideDetail['profileImg'] == null ||
                                      guideDetail['profileImg'].isEmpty
                                  ? Icon(Icons.person,
                                      size: 30, color: Colors.grey)
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '${guideDetail['firstName'] ?? ''} ${guideDetail['lastName'] ?? ''}',
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
                          icon: Icons.description,
                          title: 'Description',
                          subtitle: guideDetail['description']),
                      _buildProfileListTile(
                          icon: Icons.phone,
                          title: 'Contact Number',
                          subtitle: guideDetail['contactNo']),
                      _buildProfileListTile(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: guideDetail['email']),
                      _buildProfileListTile(
                          icon: Icons.email,
                          title: 'Gender',
                          subtitle: guideDetail['gender']),
                      _buildProfileListTile(
                          icon: Icons.email,
                          title: 'Location',
                          subtitle: guideDetail['regionalLocation']),
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: SelectableText(
        subtitle ?? 'N/A',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
