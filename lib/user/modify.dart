import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Modify extends StatefulWidget {
  const Modify({super.key});

  @override
  State<Modify> createState() => _ModifyState();
}

class _ModifyState extends State<Modify> {
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
  final TextEditingController _examStartController = TextEditingController();
  final TextEditingController _examEndController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _studentsController = TextEditingController();
  final TextEditingController _status = TextEditingController();
  final TextEditingController _lecturerstatus = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _examCodeController.text = documentSnapshot['examcode'];
      _examSubjectController.text = documentSnapshot['examsubject'].toString();
      _examVenueController.text = documentSnapshot['examvenue'].toString();
      _studentsController.text = documentSnapshot['students'].toString();
      _examStartController.text =
          documentSnapshot['examduration'].toString();
      _examEndController.text =
          documentSnapshot['examtime'].toString();
      _dateController.text = documentSnapshot['endDate'].toString();
      _timeController.text = documentSnapshot['examtime'].toString();
      _lecturerstatus.text = documentSnapshot['lecturerstatus'].toString();
      _status.text = documentSnapshot['status'].toString();
    }

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
                    Row(
                      children: [

                    Text("Lecturer Status: " + _lecturerstatus.text),
                    SizedBox(width: 15,),
                    Text("Admin Status: " + _status.text),
                      ],
                    ),
                    TextField(
                      controller: _examCodeController,
                      decoration: InputDecoration(labelText: 'Code'),
                    ),
                    TextField(
                      controller: _examSubjectController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Subject'),
                    ),
                    TextField(
                      // keyboardType:
                      // TextInputType.numberWithOptions(decimal: true),
                      controller: _examVenueController,

                      decoration: InputDecoration(labelText: 'Venue'),
                    ),
                    TextField(
                      controller: _dateController,
                      // keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: 'Exam Date'),
                    ),
                    TextField(
                      controller: _examStartController,
                      // keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          InputDecoration(labelText: 'Exam Duration'),
                    ),
                    TextField(
                      controller: _examEndController,
                      // keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          InputDecoration(labelText: 'Exam Start Time'),
                    ),
                    TextField(
                      controller: _studentsController,
                      // keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          InputDecoration(labelText: 'No of Students'),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 96,
                    //     width: 380,
                    //     color: Colors.grey[200],
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               primary: Colors.red,
                    //             ),
                    //             onPressed: () {
                    //               _selectDate(context);
                    //             },
                    //             child: const Text("Choose Date"),
                    //           ),
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           Text(
                    //               "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}"),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),

                    //               Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     height: 96,
                    //     width: 380,
                    //     color: Colors.grey[200],
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Column(
                    //         children: [
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //               primary: Colors.red,
                    //             ),
                    //             onPressed: () {
                    //               _selectTime(context);
                    //             },
                    //             child: const Text("Choose Time"),
                    //           ),
                    //           const SizedBox(
                    //             height: 5,
                    //           ),
                    //           Text("${_selectedTime.format(context)}"),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                        onPressed: () async {
                          final String examcode = _examCodeController.text;
                          final String examsubject = _examSubjectController.text;
                          final String examvenue = _examVenueController.text;
                          final String examstart = _examStartController.text;
                          final String examend = _examEndController.text;
                          final String students = _studentsController.text;
                          final String date = _dateController.text;
                          final String time = _timeController.text;
                          // if (quantity) {
                          await _products.doc(documentSnapshot!.id).update({
                            'examcode': examcode,
                            'examsubject': examsubject,
                            'examvenue': examvenue,
                            'examstart': examstart,
                            'examend': examend,
                            'students': students,
                            'endDate': date,
                            'endTime': time,
                            'status': 'approved'
                          });
                          _examCodeController.text = '';
                          _examSubjectController.text = '';
                          _examVenueController.text = '';
                          _examStartController.text = '';
                          _examEndController.text = '';
                          _studentsController.text = '';
                          _dateController.text = '';
                          _timeController.text = '';
                          _status.text = '';
                          // }
                        },
                        child: Text('Modify'))
                  ]),
            ),
          );
        });
  }

  // Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
  //   if (documentSnapshot != null) {
  //     _examCodeController.text = documentSnapshot['name'];
  //     _examSubjectController.text = documentSnapshot['quantity'].toString();
  //   }

  //   // modal
  //   await showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (BuildContext ctx) {
  //         return Padding(
  //           padding: EdgeInsets.only(
  //               top: 20,
  //               right: 20,
  //               left: 20,
  //               bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
  //           child: Column(
  //               mainAxisSize: MainAxisSize.min,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 TextField(
  //                   controller: _examCodeController,
  //                   decoration: InputDecoration(labelText: 'Add Name'),
  //                 ),
  //                 TextField(
  //                   keyboardType:
  //                       TextInputType.numberWithOptions(decimal: true),
  //                   controller: _examSubjectController,
  //                   decoration: InputDecoration(labelText: 'Quantity'),
  //                 ),
  //                 SizedBox(
  //                   height: 20,
  //                 ),
  //                 ElevatedButton(
  //                     style: ElevatedButton.styleFrom(
  //                       primary: Colors.red, // Background color
  //                     ),
  //                     onPressed: () async {
  //                       final String name = _examCodeController.text;
  //                       final double? quantity =
  //                           double.tryParse(_examSubjectController.text);
  //                       // if (quantity) {
  //                       await _products
  //                           .add({'name': name, 'quantity': quantity});
  //                       _examCodeController.text = '';
  //                       _examSubjectController.text = '';
  //                       // }
  //                     },
  //                     child: Text('Update'))
  //               ]),
  //         );
  //       });
  // }

  // Future<void> _delete(String productId) async {
  //   await _products.doc(productId).delete();

  //   ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("You have successfully deleted")));
  // }

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
        title: Text("Modify Exam"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
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
                        // IconButton(
                        //     onPressed: () => _delete(documentSnapshot.id),
                        //     icon: Icon(Icons.delete)),
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
