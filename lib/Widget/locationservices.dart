import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:yatri/database/db_handler.dart';

class LocationServices {
  StreamSubscription<Position>? _positionStream;

  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      log('Location services are disabled.');
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try to ask for permissions again
        log('Location permissions are denied');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      log('Location permissions are permanently denied, we cannot request permissions.');
      return null;
    }

    // When we reach here, permissions are granted and we can continue
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      log("Latitude = ${position.latitude}");
      log("Longitude = ${position.longitude}");
      return position;
    } catch (e) {
      log('Error occurred while getting location: $e');
      return null;
    }
  }

  void getLocationUpdates() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      try {
        String url = 'https://tokma.onrender.com/api/tourist/update-location';
        Map<String, dynamic> userData = {
          'lat': position.latitude,
          'lon': position.longitude
        };
        DatabaseHelper dbHelper = DatabaseHelper();
        String? token = await dbHelper.getSession();
        if (token != null) {
          await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userData),
          );
        } else {
          log('Error: No token available');
        }
      } catch (e) {
        log('Error occurred while updating location: $e');
      }
    });
  }

  void guideLocationUpdates() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 1,
    );

    _positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) async {
      try {
        String url = 'https://tokma.onrender.com/api/guide/update-availability';
        Map<String, dynamic> userData = {
          'lat': position.latitude,
          'lon': position.longitude
        };

        DatabaseHelper dbHelper = DatabaseHelper();
        String? token = await dbHelper.getGuideSession();
        if (token != null) {
          await http.post(
            Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $token'
            },
            body: jsonEncode(userData),
          );
        } else {
          log('Error: No token available');
        }
      } catch (e) {
        log('Error occurred while updating location: $e');
      }
    });
    Future.delayed(Duration(seconds: 5), () {
      _positionStream?.cancel();
    });
  }

  void stopListening() {
    _positionStream?.cancel();
  }
}
