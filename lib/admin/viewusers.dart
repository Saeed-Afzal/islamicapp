import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

// import 'detailscreen.dart';

class View extends StatefulWidget {
  const View({super.key});

  @override
  State<View> createState() => _ViewState();
}

class _ViewState extends State<View> {
  final Query<Map<String, dynamic>> _users = FirebaseFirestore.instance
      .collection('users')
      .where('role', whereIn: ['User']);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Users'),
        backgroundColor: Colors.green,
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
                      backgroundColor: Colors.green,
                      child: Icon(Icons.person),
                    ),
                    title: Text(documentSnapshot['name']),
                    subtitle: Text('Coins: ' + documentSnapshot['coins'].toString()),
                    // trailing: SizedBox(
                    //   width: 100,
                    //   child: Row(children: []),
                    // ),
                    onTap: () {
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
