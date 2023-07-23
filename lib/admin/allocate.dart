import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AdminAllocate extends StatefulWidget {
  const AdminAllocate({super.key});

  @override
  State<AdminAllocate> createState() => _AdminAllocateState();
}

class _AdminAllocateState extends State<AdminAllocate> {
  var deliveryData;
  String date = "";
  DateTime selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('examdetails');
  // await _product.add({"name": name, "price": price});
  // await _product.update({"name": name, "price": price});
  // await _product.doc(productId).delete();

  final TextEditingController _examCodeController = TextEditingController();

  final TextEditingController _examSubjectController = TextEditingController();
  final TextEditingController _examVenueController = TextEditingController();
  final TextEditingController _examDurationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _studentsController = TextEditingController();
  final TextEditingController _status = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _examCodeController.text = documentSnapshot['examcode'];
      _examSubjectController.text = documentSnapshot['examsubject'].toString();
      _examVenueController.text = documentSnapshot['examvenue'].toString();
      _studentsController.text = documentSnapshot['students'].toString();
      _examDurationController.text =
          documentSnapshot['examduration'].toString();
      _dateController.text = documentSnapshot['endDate'].toString();
      _timeController.text = documentSnapshot['examtime'].toString();
      _status.text = documentSnapshot['status'].toString();
    }
    String _dropDownValue = 'Allocate Chief Invigilator';
    String _dropDownValue2 = 'Allocate Invigilator 1';
    String _dropDownValue3 = 'Allocate Invigilator 2';
    // modal
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton(
                      underline: SizedBox(),
                      hint: _dropDownValue == null
                          ? Text('Dropdown')
                          : Text(
                              _dropDownValue,
                              style: TextStyle(color: Colors.blue),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.blue),
                      items: documentIdsToUpdate.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                          () {
                            _dropDownValue = val!;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton(
                      underline: SizedBox(),
                      hint: _dropDownValue2 == null
                          ? Text('Dropdown')
                          : Text(
                              _dropDownValue2,
                              style: TextStyle(color: Colors.blue),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.blue),
                      items: documentIdsToUpdate1.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                          () {
                            _dropDownValue2 = val!;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton(
                      underline: SizedBox(),
                      hint: _dropDownValue3 == null
                          ? Text('Dropdown')
                          : Text(
                              _dropDownValue3,
                              style: TextStyle(color: Colors.blue),
                            ),
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.blue),
                      items: documentIdsToUpdate1.map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                          () {
                            _dropDownValue3 = val!;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                        onPressed: () async {
                          final String examcode = _examCodeController.text;
                          final String examsubject =
                              _examSubjectController.text;
                          final String examvenue = _examVenueController.text;
                          final String examstart =
                              _examDurationController.text;
                          final String students = _studentsController.text;
                          final String date = _dateController.text;
                          final String time = _timeController.text;
                          // if (quantity) {
                          await _products.doc(documentSnapshot!.id).update({
                            "ci": _dropDownValue,
                            "i1": _dropDownValue2,
                            "i2": _dropDownValue3,
                          });

                          _examCodeController.text = '';
                          _examSubjectController.text = '';
                          _examVenueController.text = '';
                          _examDurationController.text = '';
                          _studentsController.text = '';
                          _dateController.text = '';
                          _timeController.text = '';
                          _status.text = '';
                          // }
                        },
                        child: Text('Allocate'))
                  ]),
            ),
          );
        });
  }

  List<String> documentIdsToUpdate = [];
  List<String> documentIdsToUpdate1 = [];
  List<String> documentIdsToUpdate2 = [];
  void getUserData() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      var users = await FirebaseFirestore.instance
          .collection('users')
          .where("role", isEqualTo: 'Chief Invigilator')
          .get();
      var invigilators = await FirebaseFirestore.instance
          .collection('users')
          .where("role", isEqualTo: 'Invigilator')
          .get();

      for (DocumentSnapshot documentSnapshot in users.docs) {
        // Access the data within each document
        Object? data = documentSnapshot.data();
        var field1 = data as Map;

        documentIdsToUpdate.add(field1['name']);
      }

      for (DocumentSnapshot documentSnapshot in invigilators.docs) {
        // Access the data within each document
        Object? data = documentSnapshot.data();
        var field1 = data as Map;

        documentIdsToUpdate1.add(field1['name']);
      }
    } on FirebaseAuthException catch (e) {
      print(e.message);
      // return [];
    } catch (e) {
      print(e);
      // return [];
    }
  }

  @override
  void initState() {
    super.initState();
    print('object');
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _create(),
      //   child: Icon(Icons.add),
      //   backgroundColor: Colors.red,
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: Text("Allocate Invigilator"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            print(documentIdsToUpdate);
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var im;
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                //   if(documentSnapshot['image'] == 'No image to show'){

                // }
                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(documentSnapshot['image']),
                    ),
                    title: Text(documentSnapshot['examsubject']),
                    subtitle: Text(
                        'Code: ' + documentSnapshot['examcode'].toString()),
                    trailing: SizedBox(
                      width: 50,
                      child: Row(children: [
                        IconButton(
                            onPressed: () => _update(documentSnapshot),
                            icon: Icon(Icons.edit)),
                      ]),
                    ),
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

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      // firstDate: DateTime(2010),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     data: ThemeData.dark().copyWith(
      //       colorScheme: ColorScheme.light(
      //         primary: Colors.red,
      //         onPrimary: Colors.white,
      //         surface: Colors.white,
      //         background: Colors.white,
      //         // onSurface: Colors.yellow,
      //       ),
      //       dialogBackgroundColor: Colors.white,
      //     ),
      //     child: child,
      //   );
      // },
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
        deliveryData =
            "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
      });
  }
}
