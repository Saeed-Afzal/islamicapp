import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:islamicapp/user/jus_screen.dart';
import 'package:islamicapp/user/surah_detail.dart';

import 'auth/login_screen.dart';
import 'splash/splash_screen.dart';

// import 'auth/login_screen.dart';
// import 'splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Indian Ummah',
      theme: ThemeData(
          // primarySwatch: Colors.blue,
          // visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
      // home: HomePage()
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        JuzScreen.id:(context)=>JuzScreen(),
        Surahdetail.id:(context)=>Surahdetail(),
        '/SplashScreen': (BuildContext context) => SplashScreen(),
        '/LoginScreen': (BuildContext context) => LoginScreen(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  // await _product.add({"name": name, "price": price});
  // await _product.update({"name": name, "price": price});
  // await _product.doc(productId).delete();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _quantityController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _quantityController.text = documentSnapshot['quantity'].toString();
    }

    // modal
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  TextField(
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final String name = _nameController.text;
                        final double? quantity =
                            double.tryParse(_quantityController.text);
                        // if (quantity) {
                        await _products
                            .doc(documentSnapshot!.id)
                            .update({'name': name, 'quantity': quantity});
                        _nameController.text = '';
                        _quantityController.text = '';
                        // }
                      },
                      child: Text('Update'))
                ]),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Testing3")),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  return Card(
                    margin: EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(documentSnapshot['quantity'].toString()),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(children: [
                          IconButton(
                              onPressed: () => _update(documentSnapshot),
                              icon: Icon(Icons.edit))
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
      ),
    );
  }
}
