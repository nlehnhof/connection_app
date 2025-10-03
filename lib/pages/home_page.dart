import 'package:flutter/material.dart';
import 'package:riddles/pages/sidebar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: const Text(
          'Home Page',
          style: TextStyle(
            color: Colors.white,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Sidebar(),
      body: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          margin: EdgeInsets.all(20),
          child: Container(
            width: 300, // smaller width
            height: 400, // smaller height
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // vertical centering
              crossAxisAlignment: CrossAxisAlignment.center, // horizontal centering
              children: [
                Text(
                  'Welcome to your...',
                  textAlign: TextAlign.center, // ensures text is centered horizontally
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20), // vertical spacing
                Text(
                  'Center',
                  textAlign: TextAlign.center, // ensures text is centered horizontally
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'For',
                  textAlign: TextAlign.center, // ensures text is centered horizontally
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'Connection',
                  textAlign: TextAlign.center, // ensures text is centered horizontally
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),    
        ),    
      ),
    );
  }
}