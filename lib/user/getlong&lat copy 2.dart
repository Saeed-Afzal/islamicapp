import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:islamicapp/user/userdashboard.dart';

class GetLongLat3 extends StatefulWidget {
  const GetLongLat3({Key? key}) : super(key: key);

  @override
  _GetLongLat3State createState() => _GetLongLat3State();
}

class _GetLongLat3State extends State<GetLongLat3> {
  double? lat;
  double? long;
  String address = '';
  String street = '';
  List<PrayerTime> prayerTimes = [];
  String currentTime = '';

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
    String address =
        'Korangi Industrial Area Rd, Mehran Town Sector 16 Korangi, Karachi, Karachi City, Sindh 00213, Pakistan';
    final url = Uri.parse(
        // 'http://api.aladhan.com/v1/calendarByCountry?country=$country&method=8'
        // 'http://api.aladhan.com/v1/calendarByCity/2017/4?city=London&country=United Kingdom&method=2'
        // 'http://api.aladhan.com/v1/calendarByAddress/2023/6?address=$address&method=2'
        'http://api.aladhan.com/v1/timingsByAddress/05-06-2023?address=$country');
    final response = await http.get(url);
    final responseData = json.decode(response.body);
    return responseData;
  }

  getPrayerTimes(String country) async {
    try {
      final prayerTimesData = await fetchPrayerTimes(country);
      print(prayerTimesData);

      final data = prayerTimesData['data'] as Map<String, dynamic>;
      final prayerTimings = data['timings'] as Map<String, dynamic>;

      List<PrayerTime> times = [];

      prayerTimings.forEach((key, value) {
        if (key == 'Fajr' ||
            key == 'Sunrise' ||
            key == 'Dhuhr' ||
            key == 'Asr' ||
            key == 'Sunset' ||
            key == 'Maghrib' ||
            key == 'Isha') {
          times.add(PrayerTime(name: key, time: value));
        }
      });

      if (times.isNotEmpty) {
        setState(() {
          prayerTimes = times;
        });
      } else {
        print('No prayer times found.');
      }
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

      await getAddress(value.latitude, value.longitude);

      if (lat != null && long != null) {
        getPrayerTimes(address);
      }
    }).catchError((error) {
      print("Error $error");
    });
  }

  // getAddress(lat, long) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  //   setState(() {
  //     address = placemarks[0].street! + " " + placemarks[0].country!;
  //     street = placemarks[0].street!;
  //   });
  // }

  getCurrentTime() {
    setState(() {
      currentTime = DateTime.now().toString();
    });
  }

  void getLocation() async {
    await Geolocator.checkPermission();
    // await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);

    double? addr1 = position.latitude;
    double? addr2 = position.longitude;

    print(addr1);
    if (addr1 != null) {
      double latitude = addr1;
      double longitude = addr2;
      String address = await getAddress(latitude, longitude);
      print(address);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Your Location"),
          content: Text(address),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(14),
                child: const Text("okay"),
              ),
            ),
          ],
        ),
      );

      getPrayerTimes(address);
      //     showDialog(
      //   context: context,
      //   builder: (ctx) => AlertDialog(
      //     title: const Text("Alert Dialog Box"),
      //     content: Column(
      //       children: [Text(addr1.toString()), Text(addr2.toString()), Text(address)],
      //     ),
      //     actions: <Widget>[
      //       TextButton(
      //         onPressed: () {
      //           Navigator.of(ctx).pop();
      //         },
      //         child: Container(
      //           color: Colors.white,
      //           padding: const EdgeInsets.all(14),
      //           child: const Text("okay"),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address =
            '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';
        return address;
      } else {
        return 'No address found';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  String fajrtime = "";
  String dhuhrtime = "";
  String asrtime = "";
  String maghribtime = "";
  String ishatime = "";

  bool fajrperformed = false;
  bool dhuhrperformed = false;
  bool asrperformed = false;
  bool maghribperformed = false;
  bool ishaperformed = false;

  void getUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get();
    if (userDoc.exists) {
      var userData = userDoc.data();
      var location = userData!['location'];

      fajrtime = userData!['fajr'];
      fajrtime = fajrtime.substring(0, 10);

      dhuhrtime = userData!['dhuhr'];
      dhuhrtime = dhuhrtime.substring(0, 10);

      asrtime = userData!['asr'];
      asrtime = asrtime.substring(0, 10);

      maghribtime = userData!['maghrib'];
      maghribtime = maghribtime.substring(0, 10);

      ishatime = userData!['isha'];
      ishatime = ishatime.substring(0, 10);

      getPrayerTimes(location);

      // Use the location variable as needed
      print('User location: $location');
    } else {
      print('User document does not exist');
    }
  }

  @override
  void initState() {
    super.initState();
    print('object');
    // getLocation();
    getUserData();
    // getLatLong();
    getCurrentTime();
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      getCurrentTime();
    });
  }

  bool isFajrChecked = false;
  bool isDhuhrChecked = false;
  bool isAsrChecked = false;
  bool isMaghribChecked = false;
  bool isIshaChecked = false;

  @override
  Widget build(BuildContext context) {
    if (prayerTimes.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          centerTitle: true,
          title: const Text("Prayer Times"),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // final now = DateTime.parse('2023-06-14 24:00:00Z');
    final now = DateTime.now();

    final currentTime = TimeOfDay.fromDateTime(now);
    // print(now);

    final currentDate = DateTime.now()
        .toIso8601String()
        .substring(0, 10); // Get current date in "yyyy-MM-dd" format
    final fajrTime =
        prayerTimes.firstWhereOrNull((time) => time.name == 'Fajr');
    final sunriseTime =
        prayerTimes.firstWhereOrNull((time) => time.name == 'Sunrise');
    final dhuhrTime =
        prayerTimes.firstWhereOrNull((time) => time.name == 'Dhuhr');
    final asrTime = prayerTimes.firstWhereOrNull((time) => time.name == 'Asr');
    final sunsetTime =
        prayerTimes.firstWhereOrNull((time) => time.name == 'Sunset');
    final maghribTime =
        prayerTimes.firstWhereOrNull((time) => time.name == 'Maghrib');
    final ishaTime =
        prayerTimes.firstWhereOrNull((time) => time.name == 'Isha');

    bool isAfter(TimeOfDay time1, TimeOfDay time2) {
      if (time1.hour > time2.hour) {
        return true;
      } else if (time1.hour == time2.hour) {
        return time1.minute > time2.minute;
      }
      return false;
    }

    bool isBefore(TimeOfDay time1, TimeOfDay time2) {
      if (time1.hour < time2.hour) {
        return true;
      } else if (time1.hour == time2.hour) {
        return time1.minute < time2.minute;
      }
      return false;
    }

// for Fajr
    final showFajrCheckbox1 = fajrTime != null &&
        sunriseTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${fajrTime.time}:00")));

    final showFajrCheckbox2 = fajrTime != null &&
        sunriseTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${sunriseTime.time}:00")));

    final showFajrCheckbox =
        showFajrCheckbox1 == true && showFajrCheckbox2 == false ? true : false;

// print(DateTime.parse("$currentDate ${sunriseTime!.time}:00"));
// print(showFajrCheckbox1);
// print("FajrCheckbox1");
// print(showFajrCheckbox2);
// print("FajrCheckbox2");

// for Dhuhr
    final showDhuhrCheckbox1 = dhuhrTime != null &&
        asrTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${dhuhrTime.time}:00")));

    final showDhuhrCheckbox2 = dhuhrTime != null &&
        asrTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${asrTime.time}:00")));
    final showDhuhrCheckbox =
        showDhuhrCheckbox1 == true && showDhuhrCheckbox2 == false
            ? true
            : false;

    // for Asr
    final showAsrCheckbox1 = asrTime != null &&
        asrTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${asrTime.time}:00")));

    final showAsrCheckbox2 = asrTime != null &&
        sunsetTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${sunsetTime.time}:00")));
    final showAsrCheckbox =
        showAsrCheckbox1 == true && showAsrCheckbox2 == false ? true : false;

    // print(showAsrCheckbox1);
    // print(showAsrCheckbox2);
    // print(showAsrCheckbox);

    // for Magrib
    final showMaghribCheckbox1 = maghribTime != null &&
        maghribTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${maghribTime.time}:00")));

    final showMaghribCheckbox2 = maghribTime != null &&
        ishaTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${ishaTime.time}:00")));
    final showMaghribCheckbox =
        showMaghribCheckbox1 == true && showMaghribCheckbox2 == false
            ? true
            : false;

    // print(showMaghribCheckbox1);
    // print(showMaghribCheckbox2);
    // print(showMaghribCheckbox);

    // for Isha
    final showIshaCheckbox1 = maghribTime != null &&
        ishaTime != null &&
        isAfter(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${ishaTime.time}:00")));

    final showIshaCheckbox2 = ishaTime != null &&
        fajrTime != null &&
        isBefore(
            currentTime,
            TimeOfDay.fromDateTime(
                DateTime.parse("$currentDate ${fajrTime.time}:00")));
    final showIshaCheckbox =
        showIshaCheckbox1 == true && showIshaCheckbox2 == false ? true : false;

    // print(showIshaCheckbox1);
    // print(showIshaCheckbox2);
    // print("showIshaCheckbox");
    // print(showIshaCheckbox);

// repeatition work
// print(dhuhrtime);
// if (dhuhrtime != null) {
//   // print(dhuhrtime);
// DateTime currentDate2 = DateTime.now();
// DateTime abc = DateTime.parse(dhuhrtime);
// DateFormat('YYYY-MM-dd').format(abc);
//         DateTime nextQuestionDate = abc.add(Duration(days: 1));

// dhuhrperformed = currentDate2.compareTo(abc) == 0;
// //  print(dhuhrperformed);
// }

    DateTime now1 = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now1);
    if (fajrtime != null) {
      fajrperformed = fajrtime == formattedDate;
    }
    if (dhuhrtime != null) {
      dhuhrperformed = dhuhrtime == formattedDate;
    }
    if (asrtime != null) {
      asrperformed = asrtime == formattedDate;
    }
    if (maghribtime != null) {
      maghribperformed = maghribtime == formattedDate;
    }
    if (ishatime != null) {
      ishaperformed = ishatime == formattedDate;
    }

// repeatition work

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text("Prayer Times"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              "Current Time: $currentTime",
              style: TextStyle(fontSize: 20),
            )),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.green,
              height: 2,
            ),
            // if (showFajrCheckbox)
            // CheckboxListTile(
            //   title: Text('Fajr'),
            //   value: false, // Change this value based on the checkbox state
            //   onChanged: (bool? value) {
            //     // Handle checkbox state changes
            //   },
            // ),
            if (showFajrCheckbox ||
                showDhuhrCheckbox ||
                showAsrCheckbox ||
                showMaghribCheckbox ||
                showIshaCheckbox)
              Center(
                  child: Text(
                "Mark Your Namaz Completed",
                style: TextStyle(fontSize: 20),
              )),
            if (showFajrCheckbox && !fajrperformed)
              CheckboxListTile(
                title: Text('Fajr'),
                value:
                    isFajrChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) async {
                  setState(() {
                    isFajrChecked = value!;
                  });
                  print(isFajrChecked);
                  print("isFajrChecked");
                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseFirestore firestoreInstance =
                      FirebaseFirestore.instance;

                  await firestoreInstance
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .update({
                    'coins': FieldValue.increment(1),
                    'fajr': DateTime.now().toIso8601String()
                  });
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert!"),
                      content: Text("Your coins are updated"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Navigator.of(ctx).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserDahboard()),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(14),
                            child: const Text("okay"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            if (showDhuhrCheckbox && !dhuhrperformed)
              CheckboxListTile(
                title: Text('Dhuhr'),
                value:
                    isDhuhrChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) async {
                  setState(() {
                    isDhuhrChecked = value!;
                  });

                  print(isDhuhrChecked);
                  print("isDhuhrChecked");

                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseFirestore firestoreInstance =
                      FirebaseFirestore.instance;

                  await firestoreInstance
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .update({
                    'coins': FieldValue.increment(1),
                    'dhuhr': DateTime.now().toIso8601String()
                  });
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert!"),
                      content: Text("Your coins are updated"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Navigator.of(ctx).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserDahboard()),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(14),
                            child: const Text("okay"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            if (showAsrCheckbox && !asrperformed)
              CheckboxListTile(
                title: Text('Asr'),
                value:
                    isAsrChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) async {
                  setState(() {
                    isAsrChecked = value!;
                  });
                  print(isAsrChecked);
                  print("isAsrChecked");
                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseFirestore firestoreInstance =
                      FirebaseFirestore.instance;

                  await firestoreInstance
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .update({
                    'coins': FieldValue.increment(1),
                    'asr': DateTime.now().toIso8601String()
                  });
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert!"),
                      content: Text("Your coins are updated"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Navigator.of(ctx).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserDahboard()),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(14),
                            child: const Text("okay"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            if (showMaghribCheckbox && !maghribperformed)
              CheckboxListTile(
                title: Text('Maghrib'),
                value:
                    isMaghribChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) async {
                  setState(() {
                    isMaghribChecked = value!;
                  });
                  print(isMaghribChecked);
                  print("isMaghribChecked");
                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseFirestore firestoreInstance =
                      FirebaseFirestore.instance;

                  await firestoreInstance
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .update({
                    'coins': FieldValue.increment(1),
                    'maghrib': DateTime.now().toIso8601String()
                  });
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert!"),
                      content: Text("Your coins are updated"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Navigator.of(ctx).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserDahboard()),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(14),
                            child: const Text("okay"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            if (showIshaCheckbox && !ishaperformed)
              CheckboxListTile(
                title: Text('Isha'),
                value:
                    isIshaChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) async {
                  setState(() {
                    isIshaChecked = value!;
                  });
                  print(isIshaChecked);
                  print("isIshaChecked");
                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseFirestore firestoreInstance =
                      FirebaseFirestore.instance;

                  await firestoreInstance
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .update({
                    'coins': FieldValue.increment(1),
                    'isha': DateTime.now().toIso8601String()
                  });
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert!"),
                      content: Text("Your coins are updated"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            // Navigator.of(ctx).pop();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserDahboard()),
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(14),
                            child: const Text("okay"),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              "Namaz Timings",
              style: TextStyle(fontSize: 20),
            )),
            Expanded(
              child: ListView.builder(
                itemCount: prayerTimes.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      Icons.timer_outlined,
                      color: Colors.green,
                    ),
                    title: Text(
                      prayerTimes[index].name,
                      style: TextStyle(color: Colors.green),
                    ),
                    subtitle: Text(
                      prayerTimes[index].time,
                      style: TextStyle(color: Colors.green),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrayerTime {
  final String name;
  final String time;

  PrayerTime({required this.name, required this.time});
}

void main() {
  runApp(const MaterialApp(
    home: GetLongLat3(),
  ));
}
