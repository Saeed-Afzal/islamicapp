import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:islamicapp/user/userdashboard.dart';
import '../admin/admindashboard.dart';
import 'forgot_password.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  get key => null;
  TextEditingController emailCont = TextEditingController();

  TextEditingController passwordCont = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePasswordText = true;
  RegExp regExp = RegExp("key: \\[\\d+\\]");
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  // login(BuildContext context)
  login(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      print(emailCont.text);
      print(passwordCont.text);
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailCont.text,
        password: passwordCont.text,
      );
      route();
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => Dashboard()),
      //     (route) => false);
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Login Fail',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ));
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No user found for that email")));
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Wrong password provided for that user")));
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'err',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print(documentSnapshot.get('role'));
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "admin") {
          print('admin login');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AdminDashboard()));
        } else {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => UserDahboard()));
        }
        // else if (documentSnapshot.get('role') == "Chief Invigilator") {
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (_) => ChiefDashboard()));
        //   //   Navigator.pushReplacement(
        //   //   context,
        //   //   MaterialPageRoute(
        //   //     builder: (context) =>  UserDashboard(),
        //   //   ),
        //   // );

        //   // Navigator.of(context)
        //   //     .push(MaterialPageRoute(builder: (_) => UserDashboard()));
        // } else if (documentSnapshot.get('role') == "Invigilator") {
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (_) => InvigilatorDashboard()));
        // } else if (documentSnapshot.get('role') == "Lecturer") {
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (_) => LecturerDashboard()));
        // }
        // else if (documentSnapshot.get('role') == "Student") {
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (_) => StudentDashboard()));
        // }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        // SafeArea(

        //   child: MaterialApp(
        //     debugShowCheckedModeBanner: false,
        //     home:
        Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
        toolbarHeight: 40,
      ),
      body: Container(
        // width: width,
        // height: height,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Align(
                //   alignment: Alignment.center,
                //   child: SizedBox(
                //     width: 220,
                //     child: Image.asset("assets/logo.png")
                //   ),
                // ),
                const SizedBox(
                  height: 12,
                ),
                const Text(
                  'Let\'s signs you in',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                // const Text(
                //   'Welcome back, You have been missed',
                //   style: TextStyle(color: Colors.grey),
                // ),
                const SizedBox(
                  height: 18,
                ),
                Container(
                  constraints: const BoxConstraints(maxHeight: 55),
                  child: TextFormField(
                    // controller: emailController,
                    controller: emailCont,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  constraints: const BoxConstraints(maxHeight: 55),
                  child: TextFormField(
                    toolbarOptions: ToolbarOptions(
                      copy: false,
                      cut: false,
                      paste: false,
                      selectAll: false,
                    ),
                    controller: passwordCont,
                    // controller: passwordController,
                    obscureText: _obscurePasswordText,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscurePasswordText = !_obscurePasswordText;
                          });
                        },
                        child: Icon(_obscurePasswordText
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // InkWell(
                    //     onTap: () {
                    //       // addUserCourseData();

                    //       showDialog(
                    //         context: context,
                    //         barrierDismissible: false,
                    //         builder: (context) {
                    //           return AlertDialog(
                    //             content:
                    //                 Text("Are you sure you want to proceed?"),
                    //             actions: <Widget>[
                    //               TextButton(
                    //                 child: const Text('Cancel'),
                    //                 onPressed: () {
                    //                   Navigator.of(context).pop();
                    //                 },
                    //               ),
                    //               TextButton(
                    //                 child: const Text('Yes'),
                    //                 onPressed: () async{
                    //                   // // validation();
                    //                   // Navigator.of(context)
                    //                   // .push(MaterialPageRoute(builder: (_) => const LoginPage()));
                    //                 },
                    //               )
                    //             ],
                    //           );
                    //         },
                    //       );
                    //     },
                    //     child: const Text(
                    //       'Forgot Password?',
                    //       style: TextStyle(
                    //           color: Colors.red,
                    //           fontSize: 16,
                    //           fontWeight: FontWeight.bold),
                    //     )),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    // width: width,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(400, 40),
                      ),
                      onPressed: () {
                        login(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(fontSize: 18),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => ForgotPassword()));
                    },
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Didn\'t have an account? ',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUpPage(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    )

        //   ),
        // )
        ;
    //   return Scaffold(
    //     appBar: AppBar(
    //       title: Text('Login'),
    //       // automaticallyImplyLeading: false
    //     ),
    //     body: Container(
    //       padding: EdgeInsets.all(16),
    //       child: Form(
    //         key: _formKey,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             TextFormField(
    //               keyboardType: TextInputType.emailAddress,
    //               decoration: InputDecoration(
    //                 hintText: 'Email',
    //                 labelText: 'Email',
    //               ),
    //               validator: (value) {
    //                 if (value!.isEmpty) {
    //                   return 'Please enter your email';
    //                 }
    //                 return null;
    //               },
    //             ),
    //             TextFormField(
    //               obscureText: true,
    //               decoration: InputDecoration(
    //                 hintText: 'Password',
    //                 labelText: 'Password',
    //               ),
    //               validator: (value) {
    //                 if (value!.isEmpty) {
    //                   return 'Please enter your password';
    //                 }
    //                 return null;
    //               },
    //             ),
    //             SizedBox(height: 20),
    //             ElevatedButton(
    //               onPressed: () {
    //                 if (_formKey.currentState!.validate()) {
    //                   // TODO: Add login functionality
    //                 }
    //               },
    //               child: Text('Login'),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
  }
}
