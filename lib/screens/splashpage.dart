import 'dart:async';
import 'package:flutter/material.dart';
import 'package:weather_app/screens/getstartedpage.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => GetStartedPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF06040F),
              Color(0xFF1B0E55),
              Color(0xFF2D1583),
              Color(0xFFA316D1),
              Color(0xFFF675EB),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Weather Icon
              Image.asset(
                'images/logo.png', // Add your weather icon image here
                height: 400,
              ),
              // const SizedBox(height: 20),
              // // Title
              // const Text(
              //   'Weather',
              //   style: TextStyle(
              //     fontSize: 50,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
              // const Text(
              //   'ForeCasts',
              //   style: TextStyle(
              //     fontSize: 50,
              //     fontWeight: FontWeight.bold,
              //     color: Color(0xFFFDBF50), 
              //   ),
              // ),
              // const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
