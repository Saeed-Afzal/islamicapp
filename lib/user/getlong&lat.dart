import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetLongLat extends StatefulWidget {
  const GetLongLat({Key? key}) : super(key: key);

  @override
  _GetLongLatState createState() => _GetLongLatState();
}

class _GetLongLatState extends State<GetLongLat> {
  double? lat;
  double? long;
  String address = '';
  String street = '';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Map<String, dynamic>> fetchPrayerTimes(String country) async {
    print(country);
    // String address = street + ' ' + country;
    print("address");
    String address = 'Korangi Industrial Area Rd, Mehran Town Sector 16 Korangi, Karachi, Karachi City, Sindh 00213, Pakistan';
    final url = Uri.parse(
        // 'http://api.aladhan.com/v1/calendarByCountry?country=$country&method=8'
        // 'http://api.aladhan.com/v1/calendarByCity/2017/4?city=London&country=United Kingdom&method=2'
        // 'http://api.aladhan.com/v1/calendarByAddress/2023/6?address=$address&method=2'
        'http://api.aladhan.com/v1/timingsByAddress/05-06-2023?address=$country'
        
        );
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    return responseData;
  }

  getPrayerTimes(String country) async {
    try {
      final prayerTimesData = await fetchPrayerTimes(country);
      print(prayerTimesData);

      final data = prayerTimesData['data'] as List<dynamic>;
      final prayerTimes = data[0]['timings'] as Map<String, dynamic>;

      prayerTimes.forEach((key, value) {
        print('$key: $value');
      });
    } catch (e) {
      print('Error fetching prayer times: $e');
    }
  }

  getLatLong() {
    
    Future<Position> data = _determinePosition();
    data.then((value) async {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
await Geolocator.openAppSettings();
await Geolocator.openLocationSettings();
     await getAddress(value.latitude, value.longitude);

      if (lat != null && long != null) {
        getPrayerTimes(address);
      }
    }).catchError((error) {
      print("Error $error");
    });
  }

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    setState(() {
      address = placemarks[0].street! + " " +  placemarks[0].country!;
      street = placemarks[0].street!;
    });
  }


  // @override
  // void initState() {
  //   super.initState();
  //   print('object');
  //   getLatLong();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Pending........."),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Lat : $lat"),
            Text("Long : $long"),
            Text("Address : $address "),
            ElevatedButton(
              onPressed: getLatLong,
              child: const Text("Get Location"),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: GetLongLat(),
  ));
}
