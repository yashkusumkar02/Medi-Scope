import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscope/screens/detection/skin_cancer_screen.dart';

class SkinCancerDetectionWidget extends StatelessWidget {
  final String title = 'Skin Cancer';
  final String subtitle = 'Detection';
  final String backgroundImagePath = 'assets/images/skin_cancer_background.png';

  const SkinCancerDetectionWidget({super.key}); // Set your image path

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0), // Add horizontal padding
      child: Container(
        width: screenWidth * 0.45, // 45% width of the screen
        height: screenHeight * 0.20, // 20% height of the screen
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // Shadow color
              spreadRadius: 1, // Spread the shadow
              blurRadius: 2, // Blur radius to soften the shadow
              offset: const Offset(0, 3), // Offset for shadow position (downward)
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: const Color(0xFF47484F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    // Handle button press
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SkinCancerDetectionPage()),
                    );
                  },
                  child: Text(
                    'GO',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
