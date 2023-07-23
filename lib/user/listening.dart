import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class Listening extends StatefulWidget {
  const Listening({super.key});

  @override
  State<Listening> createState() => _ListeningState();
}

class _ListeningState extends State<Listening> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Listen'),
          backgroundColor: Colors.green,
      actions: [
            IconButton(
              icon: const Icon(Icons.play_arrow_rounded),
              tooltip: 'Comment Icon',
              onPressed: () async {
                // await FirebaseAuth.instance.signOut();
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginScreen()),
                // );
              },
            ),
          ],

      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: quran.getVerseCount(18),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  quran.getVerse(18, index + 1, verseEndSymbol: true),
                  textAlign: TextAlign.right,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
