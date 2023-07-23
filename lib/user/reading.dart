import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;

class Reading extends StatefulWidget {
  const Reading({super.key});

  @override
  State<Reading> createState() => _ReadingState();
}

class _ReadingState extends State<Reading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reading'),
          backgroundColor: Colors.green,
      
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
