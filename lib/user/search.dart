import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

// import 'detailscreen.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _dataCollection =
      FirebaseFirestore.instance.collection('examdetails');

  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _filteredData = [];
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // void _fetchData(String query) {
  //   // Use the query to fetch the filtered data from Firebase
  //   // You can add additional logic to customize the query as per your data structure and requirements

  //   _dataCollection.where('examcode', isEqualTo: query).get();
  //   print(_dataCollection);
  // }

  void _fetchData(String query) async {
    final snapshot =
        await _dataCollection.where('examcode', isEqualTo: query).get();
    final filteredData = snapshot.docs;

    setState(() {
      _filteredData = filteredData;
    });
  }

  // final Query<Map<String, dynamic>> _users = FirebaseFirestore.instance
  //     .collection('users')
  //     .where('role', isNotEqualTo: 'admin');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Exam Code'),
        backgroundColor: Colors.red,
      ),

      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _fetchData(value);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Exam Code',
                hintText: 'Enter Exam Code',
              ),
            ),
          ),
          // TextField(
          //   controller: _searchController,
          //   decoration: InputDecoration(
          //     hintText: 'Enter exam code',
          //   ),
          //   onChanged: (value) {
          //     _fetchData(value);
          //   },
          // ),
          StreamBuilder<QuerySnapshot>(
            stream: _dataCollection.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              final List<QueryDocumentSnapshot> filteredData = _filteredData
                  .where((doc) => doc['examcode']
                      .toString()
                      .contains(_searchController.text))
                  .toList();
              if (filteredData.isEmpty) {
                return Center(
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    //color: Colors.purple,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue, width: 3),
                    ),
                    child: Text(
                      "No Data",
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data =
                        filteredData[index].data() as Map<String, dynamic>;
                    // return ListTile(
                    //   title: Text(data['examsubject']),
                    //   subtitle: Text(data['examvenue']),
                    //   // Display other fields as needed
                    // );
                    return Container(
                        height: 420,
                        width: double.infinity,
                        //color: Colors.purple,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue, width: 3),
                        ),
                        child: Column(
                          children: [
                            Text("Exam Code: " + data['examcode'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Exam Subject: " + data['examsubject'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Exam Venue: " + data['examvenue'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Exam Date: " + data['endDate'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Exam Duration: " + data['examduration'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Exam Time: " + data['examtime'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("No of Students: " + data['students'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Chief Invigilator: " + data['ci'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Invigilator 1: " + data['i1'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Invigilator 2: " + data['i2'],
                                style: TextStyle(fontSize: 20)),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Status: " + data['status'],
                                style: TextStyle(fontSize: 20)),
                          ],
                        ));
                  },
                ),
              );
            },
          ),
        ],
      ),

      // body: Column(
      //   children: [
      //     TextField(
      //       controller: _searchController,
      //       decoration: InputDecoration(
      //         hintText: 'Enter exam code',
      //       ),
      //       onChanged: (value) {
      //         // Trigger the search query whenever the text changes
      //         _fetchData(value);
      //       },
      //     ),
      //     ElevatedButton(
      //         style: ElevatedButton.styleFrom(
      //           primary: Colors.red, // Background color
      //         ),
      //         onPressed: () {
      //           _fetchData(_searchController as String);
      //         },
      //         child: Text('Update')),
      //     StreamBuilder<QuerySnapshot>(
      //       stream: _dataCollection.snapshots(),
      //       builder:
      //           (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //         if (snapshot.hasError) {
      //           return Text('Error: ${snapshot.error}');
      //         }

      //         if (snapshot.connectionState == ConnectionState.waiting) {
      //           return CircularProgressIndicator();
      //         }

      //         final List<QueryDocumentSnapshot> filteredData = snapshot
      //             .data!.docs
      //             .where((doc) => doc['examcode']
      //                 .toString()
      //                 .contains(_searchController.text))
      //             .toList();

      //         return Expanded(
      //           child: ListView.builder(
      //             itemCount: filteredData.length,
      //             itemBuilder: (BuildContext context, int index) {
      //               final data =
      //                   filteredData[index].data() as Map<String, dynamic>;
      //               return ListTile(
      //                 title: Text(data['examsubject']),
      //                 subtitle: Text(data['examvenue']),
      //                 // Display other fields as needed
      //               );
      //             },
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),

      // body: StreamBuilder(
      //   stream: _users.snapshots(),
      //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
      //     if (streamSnapshot.hasData) {
      //       return ListView.builder(
      //         itemCount: streamSnapshot.data!.docs.length,
      //         itemBuilder: (context, index) {
      //           final item = streamSnapshot.data!.docs[index];
      //           final DocumentSnapshot documentSnapshot =
      //               streamSnapshot.data!.docs[index];
      //           return Card(
      //             margin: EdgeInsets.all(10),
      //             child: ListTile(
      //               leading: CircleAvatar(
      //                 backgroundColor: Colors.red,
      //                 child: Icon(Icons.person),
      //               ),
      //               title: Text(documentSnapshot['name']),
      //               subtitle: Text(documentSnapshot['role']),
      //               // trailing: SizedBox(
      //               //   width: 100,
      //               //   child: Row(children: []),
      //               // ),
      //               onTap: () {
      //                 // Navigator.push(
      //                 //   context,
      //                 //   MaterialPageRoute(
      //                 //       builder: (context) => DetailScreen(item: item)),
      //                 // );
      //               },
      //             ),
      //           );
      //         },
      //       );
      //     }
      //     return const Center(
      //       child: Text('no data'),
      //     );
      //   },
      // ),
    );
  }
}
