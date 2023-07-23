import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:islamicapp/admin/addQuiz.dart';
import 'package:islamicapp/admin/viewquiz.dart';
import 'package:islamicapp/admin/viewusers.dart';

import '../auth/login_screen.dart';
import 'update.dart';


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Admin Dashboard'),
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
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  trailing: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Container(
                      // padding: EdgeInsets.only(right: 24.0),
                      // decoration: new BoxDecoration(
                      //     border: new Border(
                      //         left: new BorderSide(
                      //             width: 2.0, color: Colors.red))),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                  ),
                  title: Text(
                    'Admin',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),

                  subtitle: Row(
                    children: <Widget>[
                      // Expanded(
                      //     flex: 1,
                      //     child: Container(
                      //       // tag: 'hero',
                      //       child: LinearProgressIndicator(
                      //           backgroundColor:
                      //               Color.fromRGBO(209, 224, 224, 0.2),
                      //           value: 3,
                      //           valueColor:
                      //               AlwaysStoppedAnimation(Colors.red)),
                      //     )),
                      Expanded(
                        flex: 4,
                        child: Padding(
                            padding: EdgeInsets.only(left: 0.0),
                            child: Text('admin@gmail.com',
                                style: TextStyle(color: Colors.black))),
                      )
                    ],
                  ),
                  // trailing: Icon(Icons.keyboard_arrow_right,
                  //     color: Colors.white, size: 30.0),
                  // onTap: () {

                  //   Navigator.push(
                  //       context, MaterialPageRoute(builder: (context) => DetailPage()));
                  // },
                ),
                // abc
                // ListTile(
                //   leading: Icon(Icons.people),
                //   title: Text('My Profile'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Profile(),
                //       ),
                //     );
                //   },
                // ),
                ListTile(
                  leading: Icon(Icons.add_box, color: Colors.green,),
                  title: Text('Add Quiz', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddQuestionScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.question_mark, color: Colors.green,),
                  title: Text('View Quiz', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizListScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.green,),
                  title: Text('View Users', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => View(),
                      ),
                    );
                  },
                ),
                // ListTile(
                //   leading: Icon(Icons.upload),
                //   title: Text('Upload Exam Details'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => Add(),
                //       ),
                //     );
                //   },
                // ),
                // ListTile(
                //   leading: Icon(Icons.token),
                //   title: Text('View Accounts'),
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => View(),
                //       ),
                //     );
                //   },
                // ),
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
