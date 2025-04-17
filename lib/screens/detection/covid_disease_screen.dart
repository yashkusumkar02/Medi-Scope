import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../home_screen.dart';

class SymptomCheckerQuiz extends StatefulWidget {
  const SymptomCheckerQuiz({super.key});

  @override
  _SymptomCheckerQuizState createState() => _SymptomCheckerQuizState();
}

class _SymptomCheckerQuizState extends State<SymptomCheckerQuiz> {
  int _currentQuestionIndex = 0;
  Map<String, List<String>> _userResponses = {};
  bool _isLoading = false;
  String _aiAdvice = "";

  final List<Map<String, dynamic>> _questions = [
    {
      "question": "What is your main symptom?",
      "options": ["Fever", "Cough", "Headache", "Fatigue", "Chest Pain"]
    },
    {
      "question": "How long have you had this symptom?",
      "options": ["Less than a day", "1-3 days", "A week", "More than a week"]
    },
    {
      "question": "Do you have any other symptoms?",
      "options": ["Yes", "No"]
    },
  ];

  Map<String, bool> _selectedOptions = {};

  @override
  void initState() {
    super.initState();
    _initializeOptions();
  }

  void _initializeOptions() {
    _selectedOptions.clear();
    for (var option in _questions[_currentQuestionIndex]["options"]) {
      _selectedOptions[option] = false;
    }
  }

  void _nextQuestion() {
    setState(() {
      _userResponses[_questions[_currentQuestionIndex]["question"]] =
          _selectedOptions.entries.where((e) => e.value).map((e) => e.key).toList();

      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _initializeOptions();
      } else {
        _getAIResponse();
      }
    });
  }

  Future<void> _getAIResponse() async {
    setState(() => _isLoading = true);

    const String apiKey = "AIzaSyARVNQK2J9ohWgp5K7kioSRmrfeJJsKugI"; // Replace with your Gemini API Key
    final uri = Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateText?key=$apiKey");

    final String prompt = """
      A patient reports the following symptoms:
      ${_userResponses.entries.map((e) => "${e.key}: ${e.value.join(', ')}").join('\n')}

      Based on these symptoms, what could be the possible medical conditions and recommended actions?
    """;

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "prompt": {"text": prompt},
        "temperature": 0.7,
        "maxTokens": 200
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _aiAdvice = data["candidates"][0]["output"] ?? "No advice available.";
        _isLoading = false;
      });
    } else {
      setState(() {
        _aiAdvice = "Failed to fetch AI response. Try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI Symptom Checker",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(controller: PersistentTabController(initialIndex: 0)),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: progress, backgroundColor: Colors.grey[300], color: Colors.blue),
          const SizedBox(height: 10),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _aiAdvice.isNotEmpty
                ? _buildResultScreen()
                : _buildQuestionScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _questions[_currentQuestionIndex]["question"],
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ..._selectedOptions.keys.map(
                (option) => Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: CheckboxListTile(
                title: Text(option, style: GoogleFonts.poppins(fontSize: 16)),
                value: _selectedOptions[option],
                activeColor: Colors.blue,
                onChanged: (bool? value) {
                  setState(() {
                    _selectedOptions[option] = value!;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedOptions.containsValue(true) ? _nextQuestion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "AI Advice:",
            style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            _aiAdvice,
            style: GoogleFonts.poppins(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentQuestionIndex = 0;
                _userResponses.clear();
                _aiAdvice = "";
                _initializeOptions();
              });
            },
            child: const Text("Restart Quiz"),
          ),
        ],
      ),
    );
  }
}
