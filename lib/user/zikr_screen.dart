import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:islamicapp/user/userdashboard.dart';
import 'package:islamicapp/user/zikr_o_askaar.dart';
import 'package:video_player/video_player.dart';

import 'zikr_o_askaar2.dart';
import 'zikr_o_askaar3.dart';

class ZikrScreen extends StatefulWidget {
  const ZikrScreen({Key? key}) : super(key: key);

  @override
  State<ZikrScreen> createState() => _ZikrScreenState();
}

class _ZikrScreenState extends State<ZikrScreen> {
  //video
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  Widget build(BuildContext context) {
    // Retrieve the size of the screen
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // Scaffold widget with an AppBar and a body
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Zikr o Azkaar'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              // Container for the video player
              margin: EdgeInsets.all(10),
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image.asset('assets/1.jpeg'),
                    Container(
                      child: Column(
                        children: [
                          // Padding(
                          //   padding: const EdgeInsets.all(20.0),
                          //   child: Container(
                          //     width: size.width,
                          //     height: 80,
                          //     decoration: BoxDecoration(
                          //       border: Border.all(color: Colors.green),
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment:
                          //           MainAxisAlignment.spaceAround,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Text(
                          //           "First Zikr Video",
                          //           style: TextStyle(fontSize: 22),
                          //         ),
                          //         ElevatedButton(
                          //           style: ElevatedButton.styleFrom(
                          //             primary: Colors.green,
                          //           ),
                          //           onPressed: () {
                          //             Navigator.push(
                          //               context,
                          //               MaterialPageRoute(
                          //                 builder: (context) => ZikrOAskaar(),
                          //               ),
                          //             );
                          //           },
                          //           child: Icon(
                          //             Icons.play_arrow,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                         
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: size.width,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Morning Azkar",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ZikrOAskaar2(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.play_arrow,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                                                  Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              width: size.width,
                              height: 80,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Evening Azkar",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ZikrOAskaar3(),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.play_arrow,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
