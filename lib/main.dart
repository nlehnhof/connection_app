import 'package:flutter/material.dart';
import 'package:riddles/pages/home_page.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      home: HomePage(),
    );
  }
}

