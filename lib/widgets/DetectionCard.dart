import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String backgroundImagePath;
  final VoidCallback onTap; // Add onTap callback for navigation

  const DetectionCard({super.key, 
    required this.title,
    required this.subtitle,
    required this.backgroundImagePath,
    required this.onTap, // Initialize the onTap callback
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap, // Handle tap to navigate to a different screen
      child: Center(
        child: Container(
          width: screenWidth * 0.9, // 90% of the screen width
          height: screenHeight * 0.20, // 20% of the screen height
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage(backgroundImagePath), // Use the background image
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // Offset for shadow position
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end, // Align content to the bottom
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ],
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
                    onPressed: onTap, // Same onTap callback for button press
                    child: Text(
                      'GO',
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth * 0.04,
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
      ),
    );
  }
}
