import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CovidDiseaseDetectionPage extends StatefulWidget {
  const CovidDiseaseDetectionPage({Key? key}) : super(key: key);

  @override
  State<CovidDiseaseDetectionPage> createState() =>
      _CovidDiseaseDetectionPage();
}

class _CovidDiseaseDetectionPage extends State<CovidDiseaseDetectionPage> {
  String? _predictedOutput;
  String? _uploadedImagePath;

  void _uploadImage() {
    setState(() {
      _uploadedImagePath = "assets/images/sample_image.png";
    });
  }

  void _predictOutput() {
    setState(() {
      _predictedOutput = "Detected: Negative for Lung Cancer";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.withOpacity(0.3),
                ),
                child: _uploadedImagePath == null
                    ? const Icon(Icons.image, size: 50, color: Colors.white)
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    _uploadedImagePath!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333242),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Upload Image",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _predictOutput,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF333242),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Predict",
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 24),
              if (_predictedOutput != null)
                Text(
                  _predictedOutput!,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
