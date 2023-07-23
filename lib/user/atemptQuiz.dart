import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String questionText;
  final List<String> options;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.options,
    required this.correctAnswer,
  });

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'options': options,
      'correctAnswer': correctAnswer,
    };
  }
}

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final CollectionReference questionsCollection =
      FirebaseFirestore.instance.collection('questions');

  late String _questionText;
  List<String> _options = [];
  String _correctAnswer = '';

  @override
  void initState() {
    super.initState();
    _questionText = '';
    _options = [];
    _correctAnswer = '';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final question = Question(
        questionText: _questionText,
        options: _options,
        correctAnswer: _correctAnswer,
      );

      addQuestion(question);

      // Clear form fields
      _formKey.currentState!.reset();
      _options = [];
    }
  }

  Future<void> addQuestion(Question question) {
    return questionsCollection.add(question.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Question'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Question'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the question';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _questionText = value!;
                  },
                ),
                SizedBox(height: 16.0),
                Text('Options:'),
                Column(
                  children: _options.map((option) {
                    return Text(option);
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final option = await showDialog(
                      context: context,
                      builder: (context) => AddOptionDialog(),
                    );

                    if (option != null) {
                      setState(() {
                        _options.add(option);
                      });
                    }
                  },
                  child: Text('Add Option'),
                ),
                SizedBox(height: 16.0),
                // StatefulBuilder(
                //   builder: (BuildContext context, StateSetter setState) {
                //     return DropdownButton<String>(
                //       value: _correctAnswer,
                //       onChanged: (value) {
                //         setState(() {
                //           _correctAnswer = value!;
                //         });
                //       },
                //       items: _options.map<DropdownMenuItem<String>>((option) {
                //         return DropdownMenuItem<String>(
                //           value: option,
                //           child: Text(option),
                //         );
                //       }).toList(),
                //       hint: Text('Select Correct Answer'),
                //     );
                //   },
                // ),
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return DropdownButton<String>(
                      value: _correctAnswer,
                      onChanged: (value) {
                        setState(() {
                          _correctAnswer = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: '',
                          child: Text('Select an option'),
                        ),
                        ..._options.map<DropdownMenuItem<String>>((option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }),
                      ],
                      hint: Text('Select Correct Answer'),
                    );
                  },
                ),

                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Add Question'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddOptionDialog extends StatefulWidget {
  @override
  _AddOptionDialogState createState() => _AddOptionDialogState();
}

class _AddOptionDialogState extends State<AddOptionDialog> {
  final _optionController = TextEditingController();

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Option'),
      content: TextFormField(
        controller: _optionController,
        decoration: InputDecoration(labelText: 'Option'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final option = _optionController.text.trim();
            if (option.isNotEmpty) {
              Navigator.of(context).pop(option);
            }
          },
          child: Text('Add'),
        ),
      ],
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
      home: AddQuestionScreen(),
    );
  }
}
