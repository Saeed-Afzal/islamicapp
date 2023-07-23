// ignore_for_file: avoid_print

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String _dropDownValue = 'Student';
  static Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;
  RegExp regExp = RegExp("key: \\[\\d+\\]");
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  get key => null;
  //validation
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cPassword = TextEditingController();

  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  // File? _pickedImage;
  String? url;
  // final GlobalMethods _globalMethods = GlobalMethods();
  bool _isLoading = false;
  List<String> validChar = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  RegExp numReg = RegExp(r".*[0-9].*");
  RegExp letterReg = RegExp(r".*[A-Za-z].*");

    double? lat;
  double? long;
  String address = '';
  bool check = false;
  void getLocation() async {
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position);

    double? addr1 = position.latitude;
    double? addr2 = position.longitude;

    print(addr1);
    if (addr1 != null) {
      double latitude = addr1;
      double longitude = addr2;
       address = await getAddress(latitude, longitude);
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
    }
  }

  Future<String> getAddress(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        //  address =
        //     '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';
        address =
            '${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';
        return address;
      } else {
        return 'No address found';
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  void validation() {
    //username validate
    if (userName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("User name is empty")));
      return;
    }
    if (userName.text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Username is too short")));
      return;
    }
    for (int i = 0; i < userName.text.length; i++) {
      if (validChar.contains(userName.text[i])) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // backgroundColor: ColorConstants.statusBarColor,
            content: const Text("User name is not valid")));
        return;
      }
    }
    //    if(RegExp(r'^[A-Za-z]+$').hasMatch(userName.text))
    //  {
    //    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: ColorConstants.statusBarColor,
    //       content: const Text("User name is not valid")));
    //   return;
    //  }
    //  if(userName.text.contains(new RegExp(r'^[a-z]+$')))
    //    {
    //      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         backgroundColor: ColorConstants.statusBarColor,
    //         content: const Text("User name is not valid")));
    //     return;
    //    }
    //email validate

    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is empty")));
      return;
    } else if (!email.text.contains("@") || !email.text.contains(".")) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Email is not valid")));
      return;
    }
    //phone
    if (phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Phone Number is empty")));
      return;
    }
    //password validate
    if (password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is empty")));
      return;
    }
    if (password.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is too short")));
      return;
    }

    if (!letterReg.hasMatch(password.text) || !numReg.hasMatch(password.text)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Password is week")));
      return;
    }
    if (cPassword.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Confirm your password first")));
      return;
    }
    if (cPassword.text.trim() != password.text.trim()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Match your password")));
      return;
    }
    if (address.trim().isEmpty ) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          // backgroundColor: ColorConstants.statusBarColor,
          content: const Text("Get your location")));
      return;
    }
    print("success");
    print(address);

    sendData();
  }

  void sendData() async {
    try {
      FocusScope.of(context).unfocus();
      setState(() {
        _isLoading = true;
      });
      var date = DateTime.now().toString();
      var dateparse = DateTime.parse(date);
      var formattedDate =
          "${dateparse.day}-${dateparse.month}-${dateparse.year}";
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());
      print("Account done");
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user?.uid)
          .set({
        "userId": auth.currentUser?.uid,
        "name": userName.text,
        "email": email.text,
        "phone": phone.text,
        "password": password.text,
        'joinedAt': formattedDate,
        'createdAt': Timestamp.now(),
        'image': "",
        // 'role': "user",
        // 'role': _dropDownValue,
        'role': 'User',
        'status': "approved",
        "coins": 0,
        "location": address,
        "fajr": "2023-06-01T15:04:26.708141",
        "dhuhr": "2023-06-01T15:04:26.708141",
        "asr": "2023-06-01T15:04:26.708141",
        "maghrib": "2023-06-01T15:04:26.708141",
        "isha": "2023-06-01T15:04:26.708141"
      });
      await auth.signOut();
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => LoginScreen()));
      //   Navigator.push(
      // context,
      // new MaterialPageRoute(
      //     builder: (BuildContext context) =>
      //     LoginScreen()));
      // Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // backgroundColor: ColorConstants.statusBarColor,
            content: const Text("The password provided is too weak.")));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // backgroundColor: ColorConstants.statusBarColor,
            content: const Text("Account already exist for that email")));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            // backgroundColor: ColorConstants.statusBarColor,
            content: Text(e.code)));
        print('The account already exists for that email.');
      }
      await FirebaseAuth.instance.currentUser?.delete();
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sign Up'),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.green,
        ),
        body: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: SizedBox(
                  //     width: 220,
                  //     child: Image.asset("assets/logo.png"),
                  //   ),
                  // ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'Let\'s register your account in',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    'Enter your detail below and free signup now',
                    style: TextStyle(color: Colors.grey),
                  ),

//                   DropdownButton<String>(
//   // Step 3.
//   value: dropdownValue,
//   // Step 4.
//   items: <String>['Dog', 'Cat', 'Tiger', 'Lion']
//       .map<DropdownMenuItem<String>>((String value) {
//     return DropdownMenuItem<String>(
//       value: value,
//       child: Text(
//         value,
//         style: TextStyle(fontSize: 30),
//       ),
//     );
//   }).toList(),
//   // Step 5.
//   onChanged: (String? newValue) {
//     setState(() {
//       dropdownValue = newValue!;
//     });
//   },
// ),
                  const SizedBox(
                    height: 18,
                  ),
                  // Text(
                  //   "Role",
                  //   style: TextStyle(fontSize: 16),
                  // ),
                  //  const SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(5.0),
                  //     border: Border.all(
                  //         color: Colors.black,
                  //         style: BorderStyle.solid,
                  //         width: 0.80),
                  //   ),
                  //   child: DropdownButton(
                  //     underline: SizedBox(),
                  //     hint: _dropDownValue == null
                  //         ? Text('Dropdown')
                  //         : Text(
                  //             _dropDownValue,
                  //             style: TextStyle(color: Colors.blue),
                  //           ),
                  //     isExpanded: true,
                  //     iconSize: 30.0,
                  //     style: TextStyle(color: Colors.blue),
                  //     items: ['Student','Chief Invigilator', 'Invigilator', 'Lecturer'].map(
                  //       (val) {
                  //         return DropdownMenuItem<String>(
                  //           value: val,
                  //           child: Text(val),
                  //         );
                  //       },
                  //     ).toList(),
                  //     onChanged: (val) {
                  //       setState(
                  //         () {
                  //           _dropDownValue = val!;
                  //         },
                  //       );
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 18,
                  // ),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      controller: userName,
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      controller: email,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      controller: phone,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        hintText: 'Phone',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      toolbarOptions: ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      controller: password,
                      obscureText: _obscurePasswordText,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePasswordText = !_obscurePasswordText;
                            });
                          },
                          child: Icon(_obscurePasswordText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 55),
                    child: TextFormField(
                      toolbarOptions: ToolbarOptions(
                        copy: false,
                        cut: false,
                        paste: false,
                        selectAll: false,
                      ),
                      controller: cPassword,
                      obscureText: _obscureConfirmPasswordText,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureConfirmPasswordText =
                                  !_obscureConfirmPasswordText;
                            });
                          },
                          child: Icon(_obscureConfirmPasswordText
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                            ),
                            onPressed: getLocation,
                            child: Text("Get Location")),
                        // if(check)
                        // Text(lat as String)
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                      onPressed: validation,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Register',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                              (route) => false);
                        },
                        child: const Text(
                          'Login Now',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
