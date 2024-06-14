import 'package:flutter/material.dart';
import 'package:yatri/database/db_handler.dart';

class HomeScreenForLocalGuide extends StatefulWidget {
  const HomeScreenForLocalGuide({super.key});

  @override
  State<HomeScreenForLocalGuide> createState() =>
      _HomeScreenForLocalGuideState();
}

class _HomeScreenForLocalGuideState extends State<HomeScreenForLocalGuide> {
  late Map<String, dynamic> _localGuideDetails;

  @override
  void initState() {
    super.initState();
    _fetchLocalGuideDetails();
  }

  Future<void> _fetchLocalGuideDetails() async {
    try {
      DatabaseHelper databaseHelper = DatabaseHelper();
      _localGuideDetails = await databaseHelper.getLocalGuideDetails();
      setState(() {}); // Update UI with fetched details
    } catch (e) {
      print('Error fetching local guide details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: _localGuideDetails.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile Information:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Name: ${_localGuideDetails['fname']} ${_localGuideDetails['lname']}'),
                      Text('Email: ${_localGuideDetails['email']}'),
                      Text('Contact Number: ${_localGuideDetails['phnumber']}'),
                      Text('Gender: ${_localGuideDetails['gender']}'),
                      Text('Age: ${_localGuideDetails['age']}'),
                      Text(
                          'Location: ${_localGuideDetails['province']}, ${_localGuideDetails['district']}, ${_localGuideDetails['placeName']}'),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Availability:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Status: Available'),
                      Text(
                          'Local Time: ${DateTime.now().toString().substring(11, 16)}'),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Perform logout functionality
                      _handleLogout();
                    },
                    child: Text('Logout'),
                  ),
                ),
                SizedBox(height: 16),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void _handleLogout() {
    // Implement logout functionality as per your application's requirements
    // Example: Clear session, navigate to login screen, etc.
    Navigator.pushNamed(context, '/login');
  }
}
