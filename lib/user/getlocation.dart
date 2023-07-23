import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


class MyApp2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Log In'),
          onPressed: () async {
            await checkLocationPermission(context);
          },
        ),
      ),
    );
  }

  Future<void> checkLocationPermission(BuildContext context) async {
    if (await Permission.location.isGranted) {
      // Location permission is already granted
      saveUserLocation();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      // Location permission is not granted, request it
      var status = await Permission.location.request();
      if (status.isGranted) {
        // Location permission granted, proceed to save user location and navigate to home page
        saveUserLocation();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        // Location permission denied
        print('Location permission denied');
      }
    }
  }

  void saveUserLocation() async {
    Position position;

    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error: ${e.toString()}');
      return;
    }

    // Store the latitude and longitude as a string
    String userLocation = "${position.latitude},${position.longitude}";

    // Save the user's location in SharedPreferences or perform any other necessary actions
    // ...
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page!'),
      ),
    );
  }
}
