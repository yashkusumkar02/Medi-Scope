import 'package:flutter/material.dart';
import 'package:mediscope/widgets/HistoryBox.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detection History",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1E88E5),
      ),
      body: ListView(
        children: const [
          HistoryBox(
            detectionDetails: {
              "Brain Tumor": {
                "result": "Positive",
                "date": "21-Nov-2024",
                "notes": "Detected early-stage tumor using MRI scans.",
              },
              "Skin Cancer": {
                "result": "Negative",
                "date": "20-Nov-2024",
              },
              "Lung Cancer": {
                "result": "Positive",
                "date": "19-Nov-2024",
                "notes": "Advised further diagnostic tests.",
              },
              "Covid Detection": {
                "result": "Negative",
                "date": "18-Nov-2024",
              },
            },
          ),
        ],
      ),
    );
  }
}
