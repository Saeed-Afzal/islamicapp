import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';

class GetLongLat2 extends StatefulWidget {
  const GetLongLat2({Key? key}) : super(key: key);

  @override
  _GetLongLat2State createState() => _GetLongLat2State();
}

class _GetLongLat2State extends State<GetLongLat2> {
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

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    setState(() {
      address = placemarks[0].street! + " " + placemarks[0].country!;
      street = placemarks[0].street!;
    });
  }

  getCurrentTime() {
    setState(() {
      currentTime = DateTime.now().toString();
    });
  }

  @override
  void initState() {
    super.initState();
    print('object');
    getLatLong();
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
            if (showFajrCheckbox)
              CheckboxListTile(
                title: Text('Fajr'),
                value:
                    isFajrChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) {
                  setState(() {
                    isFajrChecked = value!;
                  });
                  print(isFajrChecked);
                  print("isFajrChecked");
                },
              ),
            if (showDhuhrCheckbox)
              CheckboxListTile(
                title: Text('Dhuhr'),
                value:
                    isDhuhrChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) {
                  setState(() {
                    isDhuhrChecked = value!;
                  });
                  print(isFajrChecked);
                  print("isFajrChecked");
                },
              ),
            if (showAsrCheckbox)
              CheckboxListTile(
                title: Text('Asr'),
                value:
                    isAsrChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) {
                  setState(() {
                    isAsrChecked = value!;
                  });
                  print(isAsrChecked);
                  print("isAsrChecked");
                },
              ),
            if (showMaghribCheckbox)
              CheckboxListTile(
                title: Text('Maghrib'),
                value:
                    isMaghribChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) {
                  setState(() {
                    isMaghribChecked = value!;
                  });
                  print(isMaghribChecked);
                  print("isMaghribChecked");
                },
              ),
            if (showIshaCheckbox)
              CheckboxListTile(
                title: Text('Isha'),
                value:
                    isIshaChecked, // Change this value based on the checkbox state
                onChanged: (bool? value) {
                  setState(() {
                    isIshaChecked = value!;
                  });
                  print(isIshaChecked);
                  print("isIshaChecked");
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
                    title: Text(prayerTimes[index].name),
                    subtitle: Text(prayerTimes[index].time),
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
    home: GetLongLat2(),
  ));
}
