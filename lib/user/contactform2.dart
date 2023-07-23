import 'package:flutter/material.dart';
import 'package:islamicapp/user/userdashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emailjs/emailjs.dart';

class ContactForm extends StatefulWidget {
  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _messageController = TextEditingController();

  Future sendEmail() async {
    final service_id = 'service_3p4ey0t';
    final template_id = 'template_3st2f9i';
    final user_id = 'FXx-2Eu1PGKRnjaoY';
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');

    Map<String, dynamic> templateParams = {
      "name": _nameController.text,
      "email": _emailController.text,
      "message": _messageController.text
    };
    try {
      await EmailJS.send(
        'service_3p4ey0t',
        'template_3st2f9i',
        templateParams,
        const Options(
          publicKey: 'FXx-2Eu1PGKRnjaoY',
          privateKey: 'p2Ddl1ZrP3XZR4QJ4h7P1',
        ),
      );
      print('SUCCESS!');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Success!'),
          content: Text('Your message is sent to admin'),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Background color
              ),
              onPressed: () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserDahboard()),
                );

                print('hello');
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      print(error.toString());
    }
    // final response = await http.post(url,
    //     headers: {
    //       "origin": 'http://localhost',
    //       "Content-Type": "application/json"
    //     },
    //     body: json.encode({
    //       "service_id": service_id,
    //       "template_id": template_id,
    //       "user_id": user_id,
    //       "template-params": {
    //         "name": _nameController.text,
    //         "email": _emailController.text,
    //         "message": _messageController.text
    //       }
    //     }));
    // if (response.statusCode == 200) {
    //   // Email sent successfully
    //   print('Email sent');
    //   // You can show a success message or navigate to another screen
    // } else {
    //   // Failed to send email
    //   print('Failed to send email');
    //   // You can show an error message or handle the failure accordingly
    // }
  }

  Future<void> _sendEmail() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String message = _messageController.text;

    String subject = 'New Contact Form Submission';
    String body = 'Name: $name\nEmail: $email\nMessage: $message';

    String url =
        'mailto:indianummah.in@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Failed to launch email client');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
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
                primary: Colors.green,
              ),
              onPressed: () {
                sendEmail();
              },
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
