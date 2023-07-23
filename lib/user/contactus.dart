import 'package:flutter/material.dart';
import 'package:flutter_mailer/flutter_mailer.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  Future<void> _sendEmail() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String message = _messageController.text;

    final MailOptions mailOptions = MailOptions(
      subject: 'New Contact Form Submission',
      recipients: [
        'indianummah.in@gmail.com'
      ], // Replace with the admin's email address
      body: 'Name: $name\nEmail: $email\nMessage: $message',
    );

    try {
      await FlutterMailer.send(mailOptions);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Your message has been sent.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _nameController.clear();
                  _emailController.clear();
                  _messageController.clear();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle exceptions if necessary
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: _messageController,
                decoration: InputDecoration(labelText: 'Message'),
                maxLines: 4,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: Size(400, 40),
                ),
                onPressed: _sendEmail,
                child: Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
