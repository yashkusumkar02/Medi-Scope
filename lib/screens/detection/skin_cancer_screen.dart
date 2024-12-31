import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscope/screens/home_screen.dart';

class SkinCancerDetectionPage extends StatefulWidget {
  const SkinCancerDetectionPage({Key? key}) : super(key: key);

  @override
  State<SkinCancerDetectionPage> createState() =>
      _SkinCancerDetectionPageState();
}

class _SkinCancerDetectionPageState extends State<SkinCancerDetectionPage> {
  String? _predictedOutput;
  String? _uploadedImagePath;

  void _uploadImage() {
    setState(() {
      _uploadedImagePath = "assets/images/sample_image.png";
    });
  }

  void _predictOutput() {
    setState(() {
      _predictedOutput = "Detected: Negative for Skin Cancer";
    });
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
              'assets/images/braintumorbg.png', // You can use a different background image
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
                          builder: (context) => HomeScreen(), // Go back to the Home screen
                        ),
                      );
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
              const Spacer(),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),
                child: _uploadedImagePath == null
                    ? const Icon(Icons.image, size: 80, color: Colors.white)
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    _uploadedImagePath!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF272733),
                  minimumSize: Size(200, 50), // Same width and height for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(
                  "Upload Image",
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
                  minimumSize: Size(200, 50), // Same width and height for the button
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
