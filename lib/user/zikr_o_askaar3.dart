import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:islamicapp/user/userdashboard.dart';
import 'package:video_player/video_player.dart';

class ZikrOAskaar3 extends StatefulWidget {
  const ZikrOAskaar3({Key? key}) : super(key: key);

  @override
  State<ZikrOAskaar3> createState() => _ZikrOAskaar3State();
}

class _ZikrOAskaar3State extends State<ZikrOAskaar3> {
  //video
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Initialize the video player controller with the network video URL
    // _controller = VideoPlayerController.asset(
    //     "assets/zikr1.mp4");
    _controller = VideoPlayerController.network(
        "https://firebasestorage.googleapis.com/v0/b/islamic-app-e6a18.appspot.com/o/videos%2Fzikr3.mp4?alt=media&token=c18b289b-b223-4c5f-aca7-f266d0d901a3");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(false);
    _controller.setVolume(5.0);

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        // Video playback reached the end
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Congratulations!'),
            content: Text('You got 1 coin...'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Background color
                ),
                onPressed: () {
                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseFirestore firestoreInstance =
                      FirebaseFirestore.instance;

                  firestoreInstance
                      .collection('users')
                      .doc(auth.currentUser!.uid)
                      .update({
                    'coins': FieldValue.increment(1),
                  });
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserDahboard()),
                  );

                  print('hello');
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    // Dispose of the video player controller when the widget is disposed
    _controller.dispose();
    super.dispose();
  }

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
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       SizedBox(height: 20),
      //       Container(
      //         // Container for the video player
      //         margin: EdgeInsets.all(10),
      //         // height: 460,
      //         height: 540,
      //         width: double.infinity,
      //         decoration: BoxDecoration(
      //           color: Colors.white,
      //           borderRadius: BorderRadius.circular(15),
      //           boxShadow: [
      //             BoxShadow(
      //               color: Colors.grey.withOpacity(0.5),
      //               spreadRadius: 5,
      //               blurRadius: 7,
      //               offset: Offset(0, 3),
      //             ),
      //           ],
      //         ),
      //         child: Padding(
      //           padding: const EdgeInsets.only(top: 8.0),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               // Image.asset('assets/1.jpeg'),
      //               Container(
      //                 child: Column(
      //                   children: [
      //                     Padding(
      //                       padding: const EdgeInsets.all(20.0),
      //                       child: Container(
      //                         width: size.width,
      //                         // height: 400,
      //                         height: 480,
      //                         decoration: BoxDecoration(
      //                           border: Border.all(color: Colors.green),
      //                           borderRadius: BorderRadius.circular(10),
      //                         ),
      //                         child: Column(
      //                           // mainAxisAlignment: MainAxisAlignment.center,
      //                           crossAxisAlignment: CrossAxisAlignment.center,
      //                           children: [
      //                             SizedBox(height: 20),
      //                             Padding(
      //                               padding: const EdgeInsets.all(8.0),
      //                               child: Center(
      //                                 child: Text(
      //                                   "You get 1 coin when you see the whole video",
      //                                   textAlign: TextAlign.center,
      //                                   style: TextStyle(
      //                                     fontSize: 20,
      //                                     fontWeight: FontWeight.bold,
      //                                     color: Colors.green,
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                             SizedBox(height: 20),
      //                             Container(
      //                               height: 250,
      //                               child: Stack(
      //                                 children: [
      //                                   Center(
      //                                     child: Positioned(
      //                                       top: 10,
      //                                       // left: 24,
      //                                       height: 100,
      //                                       width: 300,
      //                                       // width: size.width,
      //                                       child: FutureBuilder(
      //                                         future:
      //                                             _initializeVideoPlayerFuture,
      //                                         builder: (context, snapshot) {
      //                                           if (snapshot.connectionState ==
      //                                               ConnectionState.done) {
      //                                             return AspectRatio(
      //                                               aspectRatio: _controller
      //                                                   .value.aspectRatio,
      //                                               child: VideoPlayer(
      //                                                   _controller),
      //                                             );
      //                                           } else {
      //                                             return Center(
      //                                               child:
      //                                                   CircularProgressIndicator(),
      //                                             );
      //                                           }
      //                                         },
      //                                       ),
      //                                     ),
      //                                   ),
      //                                 ],
      //                               ),
      //                             ),
      //                             SizedBox(height: 30,),
      //                             Center(
      //                               child: Positioned(
      //                                 top: 280,
      //                                 // left: 24,
      //                                 width: 300,
      //                                 child: ElevatedButton(
      //                                   style: ElevatedButton.styleFrom(
      //                                     primary: Colors.green,
      //                                     // fixedSize: Size(260, 34)
      //                                   ),
      //                                   onPressed: () {
      //                                     setState(() {
      //                                       if (_controller.value.isPlaying) {
      //                                         print('playing');
      //                                         _controller.pause();
      //                                       } else {
      //                                         print('pause');
      //                                         _controller.play();
      //                                       }
      //                                     });
      //                                   },
      //                                   child: Icon(
      //                                     _controller.value.isPlaying
      //                                         ? Icons.pause
      //                                         : Icons.play_arrow,
      //                                   ),
      //                                 ),
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
   
         body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Container(
              // ... Your other container properties ...

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
                              height: 480,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: Text(
                                        "You get 1 coin when you see the whole video",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    height: 250,
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: FutureBuilder(
                                            future: _initializeVideoPlayerFuture,
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done) {
                                                return AspectRatio(
                                                  aspectRatio: _controller.value.aspectRatio,
                                                  child: VideoPlayer(_controller),
                                                );
                                              } else {
                                                return Center(
                                                  child: CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30,),
                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          if (_controller.value.isPlaying) {
                                            _controller.pause();
                                          } else {
                                            _controller.play();
                                          }
                                        });
                                      },
                                      child: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow,
                                      ),
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
