import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';

class Coins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('My Coins'),
        backgroundColor: Colors.green,
      ),
      body: UserCoinsData(),
    );
  }
}

class UserCoinsData extends StatefulWidget {
  @override
  State<UserCoinsData> createState() => _UserCoinsDataState();
}

class _UserCoinsDataState extends State<UserCoinsData> {
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get();
      return users;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  var imageUrl;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  addDataToDatabase() async {
    // setState(() {
    //   _isLoading = true;
    // });
    try {
      String time = DateTime.now().toString();
      var name = await firestoreInstance
          .collection('userinfo')
          .doc(auth.currentUser!.uid)
          .get();

      print('Outside of image url');
      await firestoreInstance
          .collection('userinfo')
          .doc(auth.currentUser!.uid)
          .update({'image': imageUrl});
      // setState(() {
      //   _isLoading = false;
      // });
      Navigator.of(context).pop();
    } catch (e) {
      print('$e');
      // setState(() {
      //   _isLoading = false;
      // });
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  // var name = 'Saeed Afzal';

//editname
  // editName() async {
  //   try {
  //     await firestoreInstance
  //         .collection('userinfo')
  //         .doc(auth.currentUser.uid)
  //         .update({
  //       // 'name': name,
  //     });
  //     // Navigator.of(context).pop(userCus);

  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getUserData(),
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            }
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: size.height,
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                left: 10, top: 0, right: 10, bottom: 0),
                            height: 135,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Container(
                                            width: size.width,
                                            height: 80,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.green,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10))),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        "You have",
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                    ),
                                                    // IconButton(
                                                    //   icon: InkWell(
                                                    //     child: const Icon(Icons
                                                    //         .edit_outlined),
                                                    //   ),
                                                    //   onPressed: () {
                                                    //     Navigator.push(
                                                    //       context,
                                                    //       MaterialPageRoute(
                                                    //           builder:
                                                    //               (context) =>
                                                    //                   ChangeName(
                                                    //                     name: snapshot
                                                    //                         .data['coins'],
                                                    //                   )),
                                                    //     );
                                                    //   },
                                                    // ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(20.0),
                                                      child: Text(
                                                          snapshot.data['coins']
                                                              .toString() + ' coins',
                                                          style: TextStyle(
                                                              fontSize: 32,
                                                              color: Colors
                                                                  .blueGrey)),
                                                    )
                                                  ],
                                                ),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.start,
                                                //   children: [
                                                //     Padding(
                                                //       padding:
                                                //           const EdgeInsets.only(
                                                //               left: 8.0),
                                                //       child: Text(
                                                //           snapshot.data['coins']
                                                //               .toString(),
                                                //           style: TextStyle(
                                                //               fontSize: 32,
                                                //               color: Colors
                                                //                   .blueGrey)),
                                                //     ),
                                                //   ],
                                                // )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   child: Column(
                                  //     children: [
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(12.0),
                                  //         child: Container(
                                  //           width: size.width,
                                  //           height: 65,
                                  //           decoration: BoxDecoration(
                                  //               border: Border.all(
                                  //                 color: Colors.red,
                                  //               ),
                                  //               borderRadius: BorderRadius.all(
                                  //                   Radius.circular(10))),
                                  //           child: Column(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.start,
                                  //             children: [
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.all(
                                  //                             8.0),
                                  //                     child: Text(
                                  //                       "Email",
                                  //                       style: TextStyle(
                                  //                         fontSize: 14,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                         color: Colors.red,
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   // IconButton(
                                  //                   //   icon: InkWell(
                                  //                   //     child: const Icon(Icons
                                  //                   //         .edit_outlined),
                                  //                   //   ),
                                  //                   //   onPressed: () {
                                  //                   //     // Navigator.push(
                                  //                   //     //   context,
                                  //                   //     //   MaterialPageRoute(
                                  //                   //     //       builder:
                                  //                   //     //           (context) =>
                                  //                   //     //               ChangeName(
                                  //                   //     //                 name: snapshot
                                  //                   //     //                     .data['name'],
                                  //                   //     //               )),
                                  //                   //     // );
                                  //                   //   },
                                  //                   // ),
                                  //                 ],
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.only(
                                  //                             left: 8.0),
                                  //                     child: Text(
                                  //                         snapshot
                                  //                             .data['email'],
                                  //                         style: TextStyle(
                                  //                             fontSize: 16,
                                  //                             color: Colors
                                  //                                 .blueGrey)),
                                  //                   ),
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  // Container(
                                  //   child: Column(
                                  //     children: [
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(12.0),
                                  //         child: Container(
                                  //           width: size.width,
                                  //           height: 85,
                                  //           decoration: BoxDecoration(
                                  //               border: Border.all(
                                  //                 color: Colors.red,
                                  //               ),
                                  //               borderRadius: BorderRadius.all(
                                  //                   Radius.circular(10))),
                                  //           child: Column(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.start,
                                  //             children: [
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.all(
                                  //                             8.0),
                                  //                     child: Text(
                                  //                       "Phone",
                                  //                       style: TextStyle(
                                  //                         fontSize: 14,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                         color: Colors.red,
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   IconButton(
                                  //                     icon: InkWell(
                                  //                       child: const Icon(Icons
                                  //                           .edit_outlined),
                                  //                     ),
                                  //                     onPressed: () {
                                  //                       Navigator.push(
                                  //                         context,
                                  //                         MaterialPageRoute(
                                  //                             builder:
                                  //                                 (context) =>
                                  //                                     ChangePhone(
                                  //                                       name: snapshot
                                  //                                           .data['phone'],
                                  //                                     )),
                                  //                       );
                                  //                     },
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.only(
                                  //                             left: 8.0),
                                  //                     child: Text(
                                  //                         snapshot
                                  //                             .data['phone'],
                                  //                         style: TextStyle(
                                  //                             fontSize: 16,
                                  //                             color: Colors
                                  //                                 .blueGrey)),
                                  //                   ),
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  // Container(
                                  //   child: Column(
                                  //     children: [
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(12.0),
                                  //         child: Container(
                                  //           width: size.width,
                                  //           height: 65,
                                  //           decoration: BoxDecoration(
                                  //               border: Border.all(
                                  //                 color: Colors.red,
                                  //               ),
                                  //               borderRadius: BorderRadius.all(
                                  //                   Radius.circular(10))),
                                  //           child: Column(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.start,
                                  //             children: [
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.all(
                                  //                             8.0),
                                  //                     child: Text(
                                  //                       "Role",
                                  //                       style: TextStyle(
                                  //                         fontSize: 14,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                         color: Colors.red,
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   // IconButton(
                                  //                   //   icon: InkWell(
                                  //                   //     child: const Icon(Icons
                                  //                   //         .edit_outlined),
                                  //                   //   ),
                                  //                   //   onPressed: () {
                                  //                   //     // Navigator.push(
                                  //                   //     //   context,
                                  //                   //     //   MaterialPageRoute(
                                  //                   //     //       builder:
                                  //                   //     //           (context) =>
                                  //                   //     //               ChangeName(
                                  //                   //     //                 name: snapshot
                                  //                   //     //                     .data['name'],
                                  //                   //     //               )),
                                  //                   //     // );
                                  //                   //   },
                                  //                   // ),
                                  //                 ],
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.only(
                                  //                             left: 8.0),
                                  //                     child: Text(
                                  //                         snapshot.data['role'],
                                  //                         style: TextStyle(
                                  //                             fontSize: 16,
                                  //                             color: Colors
                                  //                                 .blueGrey)),
                                  //                   ),
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  // Container(
                                  //   child: Column(
                                  //     children: [
                                  //       Padding(
                                  //         padding: const EdgeInsets.all(12.0),
                                  //         child: Container(
                                  //           width: size.width,
                                  //           height: 85,
                                  //           decoration: BoxDecoration(
                                  //               border: Border.all(
                                  //                 color: Colors.red,
                                  //               ),
                                  //               borderRadius: BorderRadius.all(
                                  //                   Radius.circular(10))),
                                  //           child: Column(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment.start,
                                  //             children: [
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment
                                  //                         .spaceBetween,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.all(
                                  //                             8.0),
                                  //                     child: Text(
                                  //                       "Password",
                                  //                       style: TextStyle(
                                  //                         fontSize: 14,
                                  //                         fontWeight:
                                  //                             FontWeight.bold,
                                  //                         color: Colors.red,
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //                   IconButton(
                                  //                     icon: InkWell(
                                  //                       child: const Icon(Icons
                                  //                           .edit_outlined),
                                  //                     ),
                                  //                     onPressed: () {
                                  //                       Navigator.push(
                                  //                         context,
                                  //                         MaterialPageRoute(
                                  //                             builder:
                                  //                                 (context) =>
                                  //                                     ChangePass(
                                  //                                       name: snapshot
                                  //                                           .data['password'],
                                  //                                     )),
                                  //                       );
                                  //                     },
                                  //                   ),
                                  //                 ],
                                  //               ),
                                  //               Row(
                                  //                 mainAxisAlignment:
                                  //                     MainAxisAlignment.start,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.only(
                                  //                             left: 8.0),
                                  //                     child: Text(
                                  //                         snapshot
                                  //                             .data['password'],
                                  //                         style: TextStyle(
                                  //                             fontSize: 16,
                                  //                             color: Colors
                                  //                                 .blueGrey)),
                                  //                   ),
                                  //                 ],
                                  //               )
                                  //             ],
                                  //           ),
                                  //         ),
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //     gradient: LinearGradient(
                    //       begin: Alignment.topCenter,
                    //       end: Alignment.bottomCenter,
                    //       colors: [
                    //         Color(0xFF73AEF5),
                    //         Color(0xFF61A4F1),
                    //         Color(0xFF478DE0),
                    //         Color(0xFF398AE5),
                    //       ],
                    //     ),
                    //   ),
                    //   child: Column(
                    //     children: [

                    //       // Row(
                    //       //   mainAxisAlignment: MainAxisAlignment.center,
                    //       //   children: [
                    //       //     Text(
                    //       //       snapshot.data['name'],
                    //       //       style: TextStyle(
                    //       //           fontSize: 32.0,
                    //       //           color: Colors.white,
                    //       //           fontWeight: FontWeight.bold),
                    //       //     ),
                    //       //     GestureDetector(
                    //       //       onTap: () {
                    //       //         _showCupertinoDialog();
                    //       //       },
                    //       //       child: Icon(
                    //       //         Icons.edit,
                    //       //         size: 20,
                    //       //         color: Colors.white,
                    //       //       ),
                    //       //     ),
                    //       //   ],
                    //       // ),
                    //       // SizedBox(
                    //       //   height: 20,
                    //       // ),
                    //       // Container(
                    //       //   padding: EdgeInsets.all(12),
                    //       //   margin: EdgeInsets.symmetric(horizontal: 20),
                    //       //   decoration: BoxDecoration(
                    //       //       color: Colors.white,
                    //       //       borderRadius: BorderRadius.circular(8)),
                    //       //   child: Row(
                    //       //     children: [
                    //       //       SizedBox(
                    //       //         width: 5,
                    //       //       ),
                    //       //       Icon(
                    //       //         Icons.email,
                    //       //         color: Colors.blue,
                    //       //       ),
                    //       //       SizedBox(
                    //       //         width: 10,
                    //       //       ),
                    //       //       Text(
                    //       //         snapshot.data['email'],
                    //       //         style: TextStyle(
                    //       //           color: Colors.blue,
                    //       //           fontSize: 22.0,
                    //       //           fontWeight: FontWeight.bold,
                    //       //         ),
                    //       //       )
                    //       //     ],
                    //       //   ),
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 50,
                    // ),
                    // Container(
                    //   margin: EdgeInsets.all(20),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Text(
                    //         'Location: ',
                    //         style: TextStyle(
                    //           color: Theme.of(context).primaryColor,
                    //           fontSize: 18,
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Row(
                    //         children: [
                    //           Text(
                    //             'Karachi, Pakistan',
                    //             style: TextStyle(fontSize: 18),
                    //           ),
                    //           SizedBox(width: 10),
                    //           Icon(Icons.edit),
                    //         ],
                    //       ),
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //       Center(
                    //         child: Text(
                    //           '-Contact Us-',
                    //           style: TextStyle(
                    //               fontSize: 22,
                    //               fontWeight: FontWeight.bold,
                    //               color: Colors.black),
                    //         ),
                    //       ),
                    //       SizedBox(height: 5),
                    //       Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.only(left: 8),
                    //             child: CircleAvatar(
                    //                 radius: 20,
                    //                 child: Icon(
                    //                   Icons.facebook_sharp,
                    //                   size: 35,
                    //                 )),
                    //           ),
                    //           SizedBox(
                    //             width: 20,
                    //           ),
                    //           CircleAvatar(
                    //             radius: 20,
                    //             child: FaIcon(
                    //               FontAwesomeIcons.whatsapp,
                    //               size: 25,
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             width: 20,
                    //           ),
                    //           CircleAvatar(
                    //             radius: 20,
                    //             child: FaIcon(
                    //               FontAwesomeIcons.instagram,
                    //               size: 25,
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              );
            }
            return Center(child: Text('Nothing to show'));
          }
          return Center(child: Text('Nothing to show'));
        });
  }

  void _showCupertinoDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('Cupertino Dialog'),
            content: Text('Hey! I am Coflutter!'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    // _dismissDialog();
                  },
                  child: Text('Close')),
              TextButton(
                onPressed: () {
                  print('HelloWorld!');
                  // _dismissDialog();
                },
                child: Text('HelloWorld!'),
              )
            ],
          );
        });
  }
}

// ignore: must_be_immutable
class ChangeName extends StatefulWidget {
  String name;
  ChangeName({Key? key, required this.name}) : super(key: key);
  @override
  _ChangeNameState createState() => _ChangeNameState();
}

class _ChangeNameState extends State<ChangeName> {
  TextEditingController nameField = new TextEditingController();
  // final _preferenceService = SharedPref();
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('userinfo')
          .doc(auth.currentUser!.uid)
          .get();
      return users;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  //Position _currentPosition;
  String date = "";
  DateTime selectedDate = DateTime.now();

  var userCus = DateTime.now().toString();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    ename.text = widget.name;
    super.initState();
  }

  void saveCustomization() {
    // final dataView = Data(guid: "2321312312321", isCustomized: true);
    print("Save Customization");
    // _preferenceService.saveCustomization(dataView);
  }
//edit name

  final ename = TextEditingController();

  editName() async {
    try {
      await firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'name': ename.text,
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  // @override
  void dispose() {
    super.dispose();
    // addressController.dispose();
    ename.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          height: size.height,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Changing your name"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: ename,
                    decoration: InputDecoration(
                      fillColor: Colors.red.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(),
      backgroundColor: Colors.red,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Change Name",
        // style: TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  content: Text("Are you sure you want to proceed?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        editName();
                      },
                    )
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.check,
            size: 26.0,
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

//
// ignore: must_be_immutable
class ChangePhone extends StatefulWidget {
  String name;
  ChangePhone({Key? key, required this.name}) : super(key: key);
  @override
  _ChangePhoneState createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  TextEditingController nameField = new TextEditingController();
  // final _preferenceService = SharedPref();
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('userinfo')
          .doc(auth.currentUser!.uid)
          .get();
      return users;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  //Position _currentPosition;
  String date = "";
  DateTime selectedDate = DateTime.now();

  var userCus = DateTime.now().toString();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    ename.text = widget.name;
    super.initState();
  }

  void saveCustomization() {
    // final dataView = Data(guid: "2321312312321", isCustomized: true);
    print("Save Customization");
    // _preferenceService.saveCustomization(dataView);
  }
//edit name

  final ename = TextEditingController();

  editName() async {
    try {
      await firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'phone': ename.text,
      });
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  // @override
  void dispose() {
    super.dispose();
    // addressController.dispose();
    ename.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          height: size.height,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Changing your phone"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: ename,
                    decoration: InputDecoration(
                      fillColor: Colors.red.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Phone',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(),
      backgroundColor: Colors.red,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Change Name",
        // style: TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  content: Text("Are you sure you want to proceed?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        editName();
                      },
                    )
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.check,
            size: 26.0,
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}

//
// ignore: must_be_immutable
class ChangePass extends StatefulWidget {
  String name;
  ChangePass({Key? key, required this.name}) : super(key: key);
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  TextEditingController nameField = new TextEditingController();
  // final _preferenceService = SharedPref();
  Future getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('userinfo')
          .doc(auth.currentUser!.uid)
          .get();
      return users;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  //Position _currentPosition;
  String date = "";
  DateTime selectedDate = DateTime.now();

  var userCus = DateTime.now().toString();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  @override
  void initState() {
    ename.text = widget.name;
    super.initState();
  }

  void saveCustomization() {
    // final dataView = Data(guid: "2321312312321", isCustomized: true);
    print("Save Customization");
    // _preferenceService.saveCustomization(dataView);
  }
//edit name

  final ename = TextEditingController();

  editName() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'password': ename.text,
      });
      await user!.updatePassword(ename.text);

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    }
  }

  // @override
  void dispose() {
    super.dispose();
    // addressController.dispose();
    ename.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: size.width,
          height: size.height,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Changing your password"),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: ename,
                    decoration: InputDecoration(
                      fillColor: Colors.red.shade100,
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: BackButton(),
      backgroundColor: Colors.red,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Change Name",
        // style: TextStyle(color: Colors.black),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  content: Text("Are you sure you want to proceed?"),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () {
                        editName();
                      },
                    )
                  ],
                );
              },
            );
          },
          child: Icon(
            Icons.check,
            size: 26.0,
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }
}
