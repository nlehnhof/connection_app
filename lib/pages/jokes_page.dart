import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flip_card/flip_card.dart';
import 'package:riddles/pages/sidebar.dart';

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  JokePageState createState() => JokePageState();
}

class JokePageState extends State<JokePage> {
  final PageController _controller = PageController();
  List<Map<String, String>> jokes = [];

  @override
  void initState() {
    super.initState();
    _fetchNewJokes(); // Load first 5 jokes
  }

  Future<void> _fetchNewJokes() async {
    final response = await http.get(
      Uri.parse("https://v2.jokeapi.dev/joke/Any?amount=5&lang=en&safe-mode"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      List jokesData = [];
      if (data["jokes"] != null) {
        jokesData = data["jokes"];
      } else {
        jokesData = [data];
      }

      setState(() {
        for (var joke in jokesData) {
          if (joke["type"] == "twopart") {
            jokes.add({
              "question": joke["setup"] ?? "No setup found.",
              "punchline": joke["delivery"] ?? "No delivery provided.",
            });
          } else if (joke["type"] == "single") {
            jokes.add({
              "question": joke["joke"] ?? "No joke found.",
              "punchline": "😂 That's the whole joke!",
            });
          }
        }
      });
    } else {
      setState(() {
        jokes.add({
          "question": "Error fetching jokes.",
          "punchline": "Try again later.",
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: const Text(
          "Swipe for Jokes",
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
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Sidebar(),
      body: jokes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                // When near the end, fetch more
                if (index >= jokes.length - 2) {
                  _fetchNewJokes();
                }
              },
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                final joke = jokes[index];
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                      child: FlipCard(
                        direction: FlipDirection.HORIZONTAL,
                        front: Card(
                          elevation: 20, // deeper shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            width: 300, // smaller width
                            height: 400, // smaller height
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                joke["question"]!,
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        back: Card(
                          color: Colors.green[100],
                          elevation: 20, // match shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            width: 300,
                            height: 400,
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: Text(
                                joke["punchline"]!,
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),
                );
              },
            ),
    );
  }
}
