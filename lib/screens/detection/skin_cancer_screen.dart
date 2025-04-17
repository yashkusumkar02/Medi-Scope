import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mediscope/screens/home_screen.dart';

tfl.Interpreter? _interpreter;

class SkinCancerDetectionPage extends StatefulWidget {
  const SkinCancerDetectionPage({super.key});

  @override
  State<SkinCancerDetectionPage> createState() =>
      _SkinCancerDetectionPageState();
}

class _SkinCancerDetectionPageState extends State<SkinCancerDetectionPage> {
  String? _predictedOutput;
  String? _aiResponse;
  bool _showResultBox = false;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await tfl.Interpreter.fromAsset("assets/skincancer/model_effb0.tflite");
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  Future<List<String>> _loadLabels() async {
    return ["akiec", "bcc", "bkl", "df", "mel", "nv", "vasc"];
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchAIResponse(String condition) async {
    final String apiKey = "AIzaSyARVNQK2J9ohWgp5K7kioSRmrfeJJsKugI";
    final String endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

    try {
      var response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": "What are the medical precautions for $condition?"}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          _aiResponse = data["candidates"]?[0]["content"]?["parts"]?[0]["text"] ?? "No advice available.";
        });
      } else {
        print("Error fetching AI response: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception in AI response: $e");
    }
  }

  Future<void> _predictOutput() async {
    if (_image == null) {
      print("No image selected.");
      return;
    }

    try {
      if (_interpreter == null) {
        print("Model is not loaded.");
        return;
      }

      List<String> labels = await _loadLabels();
      print("Loaded Labels: $labels");

      var rawImage = File(_image!.path).readAsBytesSync();
      img.Image? image = img.decodeImage(rawImage);
      if (image == null) {
        print("Failed to decode image.");
        return;
      }

      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

      var input = List.generate(224, (y) =>
          List.generate(224, (x) =>
          [resizedImage.getPixel(x, y).r / 255.0, resizedImage.getPixel(x, y).g / 255.0, resizedImage.getPixel(x, y).b / 255.0],
              growable: false),
          growable: false
      ).reshape([1, 224, 224, 3]);

      var output = List.filled(1 * labels.length, 0).reshape([1, labels.length]);

      _interpreter!.run(input, output);

      print("Model Output: $output");

      List<double> predictions = output[0].cast<double>();
      int maxIndex = predictions.indexOf(predictions.reduce((a, b) => a > b ? a : b));

      String predictedLabel = labels[maxIndex];

      setState(() {
        _predictedOutput = "Prediction: $predictedLabel\nConfidence: ${predictions[maxIndex].toStringAsFixed(2)}";
        _showResultBox = true;
      });

      await _fetchAIResponse(predictedLabel);
    } catch (e) {
      print("Error running model: $e");
    }
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/braintumorbg.png',
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 16),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                             HomeScreen(controller: PersistentTabController(initialIndex: 0)),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey,
                        ),
                        child: const Icon(Icons.arrow_back,
                            color: Colors.white, size: 28),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Please upload an image of a skin condition for detection.\n\n"
                        "Supported Classes:\n"
                        "1. Actinic Keratoses (akiec)\n"
                        "2. Basal Cell Carcinoma (bcc)\n"
                        "3. Benign Keratosis (bkl)\n"
                        "4. Dermatofibroma (df)\n"
                        "5. Melanoma (mel)\n"
                        "6. Melanocytic Nevi (nv)\n"
                        "7. Vascular Lesions (vasc)",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  child: _image == null
                      ? const Icon(Icons.image, size: 80, color: Colors.white)
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: Text("Upload Image from Gallery"),
                ),
                ElevatedButton(
                  onPressed: _predictOutput,
                  child: Text("Predict"),
                ),
                if (_showResultBox)
                  Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5)
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          _predictedOutput ?? "",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "AI Precautionary Advice:",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        SingleChildScrollView(
                          child: Text(
                            _aiResponse ?? "Fetching AI-generated advice...",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
