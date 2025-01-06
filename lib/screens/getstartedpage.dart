import 'package:flutter/material.dart';
import 'package:weather_app/screens/homepage.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
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
                'images/mixcloud.png', // Add your weather icon image here
                height: 300,
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Weather',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'ForeCasts',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE7BD31),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE7BD31), // Button background color
                  foregroundColor: Color(0xFF1B0E55), // Text color
                  shadowColor: Colors.black, // Shadow color
                  elevation: 8, // Elevation for shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 20, // Vertical padding
                    horizontal: 90, // Horizontal padding
                  ),
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    fontSize: 20, // Text size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
