import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizListScreen extends StatelessWidget {
  final CollectionReference questionsCollection =
      FirebaseFirestore.instance.collection('questions');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Questions'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: questionsCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No questions found.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot doc) {
              final questionData = doc.data() as Map<String, dynamic>;
              final question = Question.fromMap(questionData);

              return Card(
                elevation: 4,
                margin: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                child: ListTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.questionText,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                      SizedBox(height: 10,)
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Options:',
                        style: TextStyle(color: Colors.green, fontSize: 20),
                      ),
                      SizedBox(height: 8,),
                      ...question.options.map((option) => Text(option, style: TextStyle(fontSize: 16),)),
                      SizedBox(height: 8,),

                      Text(
                        'Correct Answer: ${question.correctAnswer}',
                        style: TextStyle(fontSize: 16, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  dense: true,
                  enabled: false,
                  selected: true,
                  selectedColor: Colors.blue,
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionText: map['questionText'],
      options: List<String>.from(map['options']),
      correctAnswer: map['correctAnswer'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizListScreen(),
    );
  }
}
