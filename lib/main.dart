import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:riddles/pages/splashscreen.dart';
import 'package:riddles/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Important for async
  // await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Joke App',
      home: HomePage(),
    );
  }
}