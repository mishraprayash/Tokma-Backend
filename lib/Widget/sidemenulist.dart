import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SideMenuList extends StatefulWidget {
  const SideMenuList({super.key});

  @override
  State<SideMenuList> createState() => _SideMenuListState();
}

class _SideMenuListState extends State<SideMenuList> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFF1a6b9c),
      body: ListView(
        children: [
          _buildMenuItem(Icons.home, 'Home', '/home'),
          _buildMenuItem(Icons.food_bank_sharp, 'Food & Lodge', '/foodlodge'),
          _buildMenuItem(Icons.emergency, 'Emergency', '/emergency'),
          _buildMenuItem(Icons.person, 'Hire Guide', '/hireguide'),
          _buildMenuItem(Icons.settings, 'Settings', '/settings'),
          _buildMenuItem(Icons.logout, 'Logout', '/login', isLogout: true),
        ],
      ),
    );
  }

  void _logout() {
    // Mock logout logic: clear session data, etc.
    // For example: SharedPreferences.clear(), API call to logout, etc.
    print("User logged out");
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
            Navigator.pushNamedAndRemoveUntil(
                context, routeName, (Route<dynamic> route) => false);
          } else {
            Navigator.pushNamed(context, routeName);
          }
        },
      ),
    );
  }
}
