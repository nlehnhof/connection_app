import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart'; // Replace with your main page

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // or your app theme color
      body: Center(
        child: Image.asset(
          'assets/images/connections_logo.png',
          width: 150,
          height: 150,
        ),
      ),
    );
  }
}
