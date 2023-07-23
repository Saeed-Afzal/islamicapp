import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class QuizQuestionScreen extends StatefulWidget {
  @override
  _QuizQuestionScreenState createState() => _QuizQuestionScreenState();
}

class _QuizQuestionScreenState extends State<QuizQuestionScreen> {
  Question? _currentQuestion;
  late String _userAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _userAnswer = '';
    _fetchQuestion();
  }

  String? newQuestionId;
  Future<void> _fetchQuestion() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    // Fetch user's last attempt data
    DocumentSnapshot userData = await firestoreInstance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get();

    Map<String, dynamic> userDataMap =
        userData.data() as Map<String, dynamic>? ?? {};

    String? lastAttemptDate = userDataMap['lastAttemptDate'];
    String? lastQuestionId = userDataMap['lastQuestionId'];

    // Query the 'questions' collection for the next question
    QuerySnapshot snapshot = await firestoreInstance
        .collection('questions')
        .where('docId', isGreaterThan: lastQuestionId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final questionData = snapshot.docs[0].data() as Map<String, dynamic>;
      final questionId = snapshot.docs[0].id; // Get the question document ID

      _currentQuestion = Question.fromMap(questionData);

      setState(() {
        newQuestionId = questionId;
        // Update the user document with the new question ID and last attempt date
        firestoreInstance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({
          // 'lastQuestionId': questionId,
          // 'lastAttemptDate': DateTime.now().toIso8601String(),
        });
      });
    }

     else {
    // No more questions available, reset to the first question
    QuerySnapshot firstQuestionSnapshot = await firestoreInstance
        .collection('questions')
        .orderBy('docId')
        .limit(1)
        .get();

    if (firstQuestionSnapshot.docs.isNotEmpty) {
      final questionData =
          firstQuestionSnapshot.docs[0].data() as Map<String, dynamic>;
      final questionId = firstQuestionSnapshot.docs[0].id; // Get the question document ID

      _currentQuestion = Question.fromMap(questionData);

      setState(() {
        newQuestionId = questionId;
        // Update the user document with the new question ID and last attempt date
        firestoreInstance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .update({
          'lastQuestionId': questionId,
          'lastAttemptDate': DateTime.now().toIso8601String(),
        });
      });
    }
  }
  }

  Future<void> _submitAnswer() async {
    if (_userAnswer == _currentQuestion!.correctAnswer) {
      setState(() {
        _isCorrect = true;
      });

      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

      // Update user's coins in the database (increment by 5)
      await firestoreInstance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .update({
        'coins': FieldValue.increment(5),
        'lastAttemptDate': DateTime.now().toIso8601String(),
        'lastQuestionId': newQuestionId,
      });
    }

    setState(() {
      _isAnswered = true;
    });

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    // Update user's last attempt date
    await firestoreInstance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({
      'lastAttemptDate': DateTime.now().toString(),
    });
  }

  void _goToNextQuestion() {
    setState(() {
      _userAnswer = '';
      _isAnswered = false;
      _isCorrect = false;
    });

    _fetchQuestion();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentQuestion == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz Question'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

    // Fetch user's last attempt data
    DocumentReference userRef =
        firestoreInstance.collection('users').doc(auth.currentUser!.uid);

    return FutureBuilder<DocumentSnapshot>(
      future: userRef.get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Quiz Question'),
              backgroundColor: Colors.green,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Quiz Question'),
              backgroundColor: Colors.green,
            ),
            body: Center(
              child: Text('User data not found.'),
            ),
          );
        }

        Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;

        DateTime lastAttemptDate = userData['lastAttemptDate'] != null
            ? DateTime.parse(userData['lastAttemptDate'])
            : DateTime(
                2000); // Use a default date if lastAttemptDate is not set

        DateTime currentDate = DateTime.now();
        DateTime nextQuestionDate = lastAttemptDate.add(Duration(days: 1));

          String formattedDate = DateFormat('yyyy-MM-dd').format(nextQuestionDate);

        if (currentDate.isBefore(nextQuestionDate)) {
          // User attempted today
          return Scaffold(
            appBar: AppBar(
              title: Text('Quiz Question'),
              backgroundColor: Colors.green,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    'Next question will be available on ${formattedDate.toString()}', style: TextStyle(fontSize: 20,),textAlign: TextAlign.center,),
              ),
            ),
          );
        } else {
          // User did not attempt today
          return Scaffold(
            appBar: AppBar(
              title: Text('Quiz Question'),
              backgroundColor: Colors.green,
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Question",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    _currentQuestion!.questionText,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Options",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _currentQuestion!.options.length,
                    itemBuilder: (context, index) {
                      final option = _currentQuestion!.options[index];
                      return RadioListTile<String>(
                        title: Text(option),
                        value: option,
                        groupValue: _userAnswer,
                        onChanged: (value) {
                          setState(() {
                            _userAnswer = value!;
                          });
                        },
                      );
                    },
                  ),
                  SizedBox(height: 16.0),
                  if (!_isAnswered)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitAnswer,
                      child: Text('Submit Answer'),
                    ),
                  if (_isAnswered)
                    _isCorrect
                        ? Text(
                            'Correct Answer! You have earned 5 coins.',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.green,
                            ),
                          )
                        : Text(
                            'Wrong Answer! Better luck next time.',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.red,
                            ),
                          ),
                  SizedBox(height: 16.0),
                  if (_isAnswered)
                    ElevatedButton(
                      onPressed: _goToNextQuestion,
                      child: Text('Next Question'),
                    ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   if (_currentQuestion == null) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: Text('Quiz Question'),
  //         backgroundColor: Colors.green,
  //       ),
  //       body: Center(
  //         child: CircularProgressIndicator(),
  //       ),
  //     );
  //   }

  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Quiz Question'),
  //       backgroundColor: Colors.green,
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             _currentQuestion!.questionText,
  //             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //           ),
  //           SizedBox(height: 16.0),
  //           ListView.builder(
  //             shrinkWrap: true,
  //             itemCount: _currentQuestion!.options.length,
  //             itemBuilder: (context, index) {
  //               final option = _currentQuestion!.options[index];
  //               return RadioListTile<String>(
  //                 title: Text(option),
  //                 value: option,
  //                 groupValue: _userAnswer,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     _userAnswer = value!;
  //                   });
  //                 },
  //               );
  //             },
  //           ),
  //           SizedBox(height: 16.0),
  //           if (!_isAnswered)
  //             ElevatedButton(
  //               onPressed: _submitAnswer,
  //               child: Text('Submit Answer'),
  //             ),
  //           if (_isAnswered)
  //             _isCorrect
  //                 ? Text(
  //                     'Correct Answer! You have earned 5 coins.',
  //                     style: TextStyle(
  //                       fontSize: 18.0,
  //                       color: Colors.green,
  //                     ),
  //                   )
  //                 : Text(
  //                     'Wrong Answer! Better luck next time.',
  //                     style: TextStyle(
  //                       fontSize: 18.0,
  //                       color: Colors.red,
  //                     ),
  //                   ),
  //           SizedBox(height: 16.0),
  //           if (_isAnswered)
  //             ElevatedButton(
  //               onPressed: _goToNextQuestion,
  //               child: Text('Next Question'),
  //             ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
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
        primarySwatch: Colors.green,
      ),
      home: QuizQuestionScreen(),
    );
  }
}
