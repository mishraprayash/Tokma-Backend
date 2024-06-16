import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yatri/database/db_handler.dart';

class SideMenuList extends StatefulWidget {
  const SideMenuList({Key? key}) : super(key: key);

  @override
  State<SideMenuList> createState() => _SideMenuListState();
}

class _SideMenuListState extends State<SideMenuList> {
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFA1662f),
      body: ListView(
        children: [
          _buildMenuItem(Icons.home, 'Home', '/homefortourist'),
          _buildMenuItem(Icons.food_bank_sharp, 'Food & Lodge', '/foodlodge'),
          _buildMenuItem(
              Icons.health_and_safety, 'Health Services', '/healthservices'),
          _buildMenuItem(Icons.local_activity, 'Activities', '/activities'),
          _buildMenuItem(Icons.person_pin_circle, 'Local Guide', '/localguide'),
          _buildMenuItem(Icons.rule_folder, 'Rule Book', '/rulebook'),
          _buildMenuItem(Icons.person, 'Profile', '/profile'),
          _buildMenuItem(Icons.logout, 'Logout', '/login', isLogout: true),
        ],
      ),
    );
  }

  void _logout() async {
    // Clear app state (login status) from SQLite database
    await _databaseHelper.updateState(false, '');

    // Navigate to the login screen and remove all other routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  Widget _buildMenuItem(IconData iconData, String text, String routeName,
      {bool isLogout = false}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.sp),
      child: ListTile(
        leading: Container(
          width: 40.sp,
          height: 40.sp,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: Center(
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
        title: Text(
          text.toUpperCase(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
        onTap: () {
          if (isLogout) {
            _logout();
          } else {
            Navigator.pushNamed(context, routeName);
          }
        },
      ),
    );
  }
}
