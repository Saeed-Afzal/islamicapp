import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

// import 'detailscreen.dart';

class CompletedExam extends StatefulWidget {
  const CompletedExam({super.key});

  @override
  State<CompletedExam> createState() => _CompletedExamState();
}

class _CompletedExamState extends State<CompletedExam> {
  final Query<Map<String, dynamic>> _users = FirebaseFirestore.instance
      .collection('examdetails')
      .where('status', isEqualTo: "closed");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Finished Exam'),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder(
        stream: _users.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final item = streamSnapshot.data!.docs[index];
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: Icon(Icons.copy),
                    ),
                    title: Text(documentSnapshot['examsubject'] + ' Code: ' + documentSnapshot['examcode']),
                    subtitle: Text(  'Absent: ' + documentSnapshot['absents'] + ' Early: ' + documentSnapshot['early'] + ' Total: '
                     + (documentSnapshot['total']).toString()),
                    // trailing: SizedBox(
                    //   width: 100,
                    //   child: Row(children: []),
                    // ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext ctx) {
                            return SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 20,
                                    right: 20,
                                    left: 20,
                                    bottom:
                                        MediaQuery.of(ctx).viewInsets.bottom +
                                            20),
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 400,
                                          width: double.infinity,
                                          //color: Colors.purple,
                                          alignment: Alignment.center,
                                          margin: const EdgeInsets.all(20),
                                          padding: const EdgeInsets.all(30),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.red, width: 3),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                  "Exam Code: " +
                                                      documentSnapshot![
                                                          'examcode'],
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Exam Subject: " +
                                                      documentSnapshot[
                                                          'examsubject'],
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Exam Venue: " +
                                                      documentSnapshot[
                                                          'examvenue'],
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Exam Date: " +
                                                      documentSnapshot[
                                                          'endDate'],
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "No of Students: " +
                                                      documentSnapshot[
                                                          'students'],
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Chief Invigilator: " +
                                                      documentSnapshot['ci'],
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Invigilator 1: " +
                                                      documentSnapshot['i1'],
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Invigilator 2: " +
                                                      documentSnapshot['i2'],
                                                  style:
                                                      TextStyle(fontSize: 20)),
                                            ],
                                          ))
                                    ]),
                              ),
                            );
                          });

                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => DetailScreen(item: item)),
                      // );
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: Text('no data'),
          );
        },
      ),
    );
  }
}
