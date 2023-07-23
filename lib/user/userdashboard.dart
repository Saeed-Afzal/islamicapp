import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:islamicapp/admin/addQuiz.dart';
import 'package:islamicapp/user/getlocation.dart';
import 'package:islamicapp/user/getlong&lat%20copy%202.dart';
import 'package:islamicapp/user/getlong&lat%20copy.dart';
import 'package:islamicapp/user/mycoins.dart';
import 'package:islamicapp/user/qari_screen.dart';
import 'package:islamicapp/user/reading.dart';
import 'package:islamicapp/user/zikr_o_askaar.dart';

import '../auth/login_screen.dart';
import 'atemptQuiz.dart';
import 'attemptquiz.dart';
import 'contactform2.dart';
import 'getlong&lat.dart';
import 'listening.dart';
import 'pdfviewer.dart';
import 'quranscreen.dart';
import 'update.dart';
import 'zikr_screen.dart';


class Users {
  final String userId;
  int coins;

  Users({
    required this.userId,
    this.coins = 0,
  });
}
class UserDahboard extends StatefulWidget {
  const UserDahboard({super.key});

  @override
  State<UserDahboard> createState() => _UserDahboardState();
}

class _UserDahboardState extends State<UserDahboard> {
  var user = 'XXwCg5KXBBh3aMdtxVXlxJ8ZPWS2';

//  final Users user = Users(userId: 'XXwCg5KXBBh3aMdtxVXlxJ8ZPWS2'); 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('User Dashboard'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Comment Icon',
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[

                // ListTile(
                //   leading: Icon(Icons.add_box),
                //   title: Text('Attempt Quiz'),
                //   onTap: () {
                //     String a = 'XXwCg5KXBBh3aMdtxVXlxJ8ZPWS2';
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => QuizScreen(user: user,),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.upload),
                //   title: Text('Upload Exam Details'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => MyApp2(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.location_city),
                //   title: Text('Get Location'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => GetLongLat(),
                //       ),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.money, color: Colors.green),
                  title: Text('My Coins', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Coins(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.hourglass_empty_sharp, color: Colors.green),
                  title: Text('Perform Namaz',  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetLongLat3(),
                      ),
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.hourglass_empty_sharp),
                //   title: Text('Get Location'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => GetLongLat(),
                //       ),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.quiz, color: Colors.green),
                  title: Text('Attempt Quiz',  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizQuestionScreen(),
                      ),
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.note, color: Colors.green),
                //   title: Text('Read Quran',  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => QuranScreen(),
                //       ),
                //     );
                //   },
                // ),
                 ListTile(
                  leading: Icon(Icons.featured_play_list_outlined, color: Colors.green),
                  title: Text('Listen Quran',  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QariListScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.video_file, color: Colors.green),
                  title: Text('Zikr o Azkaar',  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ZikrScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_mail, color: Colors.green),
                  title: Text('Contact Us',  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContactForm(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_mail, color: Colors.green),
                  title: Text('Read Quran',  style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        // builder: (context) => PDFViewerWidget(pdfPath: 'https://firebasestorage.googleapis.com/v0/b/islamic-app-e6a18.appspot.com/o/pdf%2F13-Line-Quran-with-Tajweed-rule.pdf?alt=media&token=2d0e56ba-f86c-4fb2-8b32-4c2d98c6af75',),
                        builder: (context) => PDFViewerWidget(pdfPath: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',),
                      ),
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.payment),
                //   title: Text('Allocate Invigilator'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AdminAllocate(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.people),
                //   title: Text('Search Exam Code'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Search(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.payment),
                //   title: Text('Finished Exam'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => CompletedExam(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.add_box),
                //   title: Text('Modify Exam'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Modify(),
                //       ),
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
