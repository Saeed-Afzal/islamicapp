import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  final emailCont = TextEditingController();

  @override
  void dispose() {
    emailCont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        toolbarHeight: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receive an email to reset your password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailCont,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (email) =>
                  //     email != null ? 'Enter a valid email' : null,
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    // width: width,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(400, 40),
                      ),
                      onPressed: () {
                        // login(context);
                        resetPassword();
                      },
                      icon: Icon(Icons.email_outlined),
                      label: Text('Reset Password'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            )),
      ),
    );
  }

  Future resetPassword() async {
    try {
      
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailCont.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password Reset Email Sent")));
        Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email Error')));
        Navigator.of(context).pop();
    }
  }
}
