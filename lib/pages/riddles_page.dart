import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flip_card/flip_card.dart';
import 'package:riddles/pages/sidebar.dart';

class RiddlePage extends StatefulWidget {
  const RiddlePage({super.key});

  @override
  RiddlePageState createState() => RiddlePageState();
}

class RiddlePageState extends State<RiddlePage> {
  final PageController _controller = PageController();
  List<Map<String, String>> riddles = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNewRiddles(); // Load first batch
  }

  Future<void> _fetchNewRiddles() async {
    if (_isLoading) return; // prevent double fetch
    _isLoading = true;

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8000/riddles"),
        // Uri.parse("http://127.0.0.1:8000/riddles"), // change to your API URL
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        setState(() {
          data.shuffle(); // randomize
          for (var riddle in data.take(5)) {
            riddles.add({
              "question": riddle["question"] ?? "No question found",
              "answer": riddle["answer"] ?? "No answer found",
            });
          }
        });
      } else {
        setState(() {
          riddles.add({
            "question": "Error fetching riddles.",
            "answer": "Try again later.",
          });
        });
      }
    } catch (e) {
      setState(() {
        riddles.add({
          "question": "Error fetching riddles.",
          "answer": e.toString(),
        });
      });
    } finally {
      _isLoading = false;
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
          "Swipe for Riddles",
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
      body: riddles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _controller,
              onPageChanged: (index) {
                // Fetch more riddles when near the end
                if (index >= riddles.length - 2) {
                  _fetchNewRiddles();
                }
              },
              itemCount: riddles.length,
              itemBuilder: (context, index) {
                final riddle = riddles[index];
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      front: Card(
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: 300,
                          height: 400,
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              riddle["question"]!,
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      back: Card(
                        color: Colors.green[100],
                        elevation: 20,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: 300,
                          height: 400,
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              riddle["answer"]!,
                              style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
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
