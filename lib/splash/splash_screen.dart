import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacementNamed('/LoginScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Image.asset("assets/logo.png"),
            //  Image.network(
            //   // "https://w7.pngwing.com/pngs/932/529/png-transparent-gift-boxes-3d-gift-box-lucky-draw-lucky-draw-box-button-thumbnail.png"
            //   // "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS2OoNQeH9ykAxKGr_XGzxpb6Dlaqtx8GshGY5xG0wpeySq1aart2s77Rma-stb5ERHa3w&usqp=CAU"
            //   "https://i.ibb.co/KrsFQgH/png-transparent-two-yellow-and-red-gift-boxes-illustration-drawing-computer-icons-lucky-draw-miscell.png"
            //   ),
            CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              "INDIAN UMMAH",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
