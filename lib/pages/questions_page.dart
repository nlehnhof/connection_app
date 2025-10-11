import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flip_card/flip_card.dart';
import 'package:riddles/pages/sidebar.dart';
import 'package:riddles/config.dart';

// ---------------------
// Question Model + API
// ---------------------
class Question {
  final String level;
  final String text;

  Question({required this.level, required this.text});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      level: json['level'],
      text: json['question'] ?? json['text'] ?? '',
    );
  }
}

class QuestionsApi {
  final String baseUrl;

  QuestionsApi({String? baseUrl}) : baseUrl = baseUrl ?? Config.QUESTIONS_API_URL;

  Future<List<Question>> getQuestions(String level, {int count = 5}) async {
    final response = await http.get(Uri.parse("$baseUrl/questions/$level?count=$count"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["questions"] != null) {
        return (data["questions"] as List)
            .map((q) => Question(level: level, text: q))
            .toList();
      } else if (data["question"] != null) {
        return [Question(level: level, text: data["question"])];
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load questions");
    }
  }
}

// ---------------------
// Questions Page
// ---------------------
class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  QuestionsPageState createState() => QuestionsPageState();
}

class QuestionsPageState extends State<QuestionsPage> {
  late final QuestionsApi api;
  final PageController _controller = PageController();
  final List<Question> _questions = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  String _selectedLevel = "shallow";
  final List<String> levels = ["shallow", "deep", "intimate"];

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Safe to use ApiConfig now
    api = QuestionsApi();
    setState(() => _isInitialized = true);
    _fetchNextBatch(); // fetch first batch after initialization
  }

  Future<void> _fetchNextBatch() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final newQuestions = await api.getQuestions(_selectedLevel, count: 5);
      setState(() {
        _questions.addAll(newQuestions);
      });
    } catch (e) {
      setState(() {
        _questions.add(
            Question(level: _selectedLevel, text: "Error fetching questions."));
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: const Text(
          "Swipe for Questions",
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
      body: Scaffold(
        backgroundColor: Colors.red,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Dropdown to select level
              DropdownButton<String>(
                value: _selectedLevel,
                underline: Container(),
                items: levels
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(
                            level[0].toUpperCase() + level.substring(1),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLevel = value!;
                    _questions.clear();
                    _fetchNextBatch();
                  });
                },
                iconEnabledColor: Colors.white,
                dropdownColor: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _questions.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : PageView.builder(
                        controller: _controller,
                        onPageChanged: (index) {
                          if (index >= _questions.length - 2) {
                            _fetchNextBatch();
                          }
                        },
                        itemCount: _questions.length,
                        itemBuilder: (context, index) {
                          final q = _questions[index];
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
                                        q.text,
                                        style: const TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
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
                                        "Level: ${q.level[0].toUpperCase()}${q.level.substring(1)}",
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
