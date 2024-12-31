import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:mediscope/screens/home_screen.dart';

class BrainTumorDetectionPage extends StatefulWidget {
  const BrainTumorDetectionPage({Key? key}) : super(key: key);

  @override
  State<BrainTumorDetectionPage> createState() =>
      _BrainTumorDetectionPageState();
}

class _BrainTumorDetectionPageState extends State<BrainTumorDetectionPage> {
  String? _predictedOutput;
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Load your model when the page loads
    _loadModel();
  }

  // Load the model
  Future<void> _loadModel() async {
    try {
      await Tflite.loadModel(
        model: "assets/model_unquant.tflite",
        labels: "assets/labels.txt",
      );
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
    }
  }

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Capture image from camera
  Future<void> _pickImageFromCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Predict output based on the selected image
  Future<void> _predictOutput() async {
    if (_image != null) {
      var result = await Tflite.runModelOnImage(
        path: _image!.path,
        numResults: 4, // Ensure all 4 classes are returned
        threshold: 0.5, // Adjust threshold as needed
        asynch: true,
      );

      if (result != null && result.isNotEmpty) {
        String output = '';
        for (var res in result) {
          output += 'Label: ${res['label']}, Confidence: ${res['confidence']}\n';
        }

        setState(() {
          _predictedOutput = output;
        });

        // Print the result for debugging
        print("Model result: $result");
      } else {
        print("No result returned from the model.");
      }
    } else {
      print("No image selected.");
    }
  }


  @override
  void dispose() {
    super.dispose();
    Tflite.close(); // Close the model when done
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0), // Hides the app bar
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
          Column(
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
                                HomeScreen(), // Replace with actual widget
                          ));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueGrey,
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ),
              // Text describing the available diseases
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Please upload an image of any of the following brain tumor types:\n\n"
                      "1. Pituitary\n"
                      "2. No Tumor\n"
                      "3. Meningioma\n"
                      "4. Glioma\n\n"
                      "Only these types are supported by this model.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Image display and picker buttons
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF272733),
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Upload Image from Gallery",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImageFromCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF272733),
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Take Photo with Camera",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _predictOutput,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333242),
                  minimumSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Predict",
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              if (_predictedOutput != null)
                Text(
                  _predictedOutput!,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
