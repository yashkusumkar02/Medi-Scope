import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthCalculatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the screen width and height for responsive design
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9, // 90% of the screen width
      height: screenHeight * 0.12, // 15% of the screen height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage('assets/images/health_calculator_background.png'), // Set your image path
          fit: BoxFit.cover, // To make sure the image covers the entire container
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // Shadow color
            spreadRadius: 1, // Spread the shadow
            blurRadius: 3, // Blur radius to soften the shadow
            offset: Offset(0, 3), // Offset for shadow position (downward)
          ),
        ],
      ),
      child: Stack(
        children: [
          // Health Text
          Positioned(
            left: 20,
            top: 35,
            child: Text(
              'Health',
              style: GoogleFonts.poppins( // Use Google Fonts for Poppins
                color: Colors.white,
                fontSize: screenWidth * 0.05, // Responsive font size
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          // CALCULATOR Text
          Positioned(
            left: 20,
            top: 65,
            child: Text(
              'CALCULATOR',
              style: GoogleFonts.poppins( // Use Google Fonts for Poppins
                color: Color(0xFFEBEAEC),
                fontSize: screenWidth * 0.03, // Responsive font size
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
              ),
            ),
          ),
          // TRY NOW Text
          Positioned(
            right: 20,
            top: 75,
            child: Text(
              'TRY NOW',
              style: GoogleFonts.poppins( // Use Google Fonts for Poppins
                color: Color(0xFFEBEAEC),
                fontSize: screenWidth * 0.03, // Responsive font size
                fontWeight: FontWeight.w500,
                letterSpacing: 0.55,
              ),
            ),
          ),
          // Circle Button
          Positioned(
            right: 30,
            top: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward, // Next icon
                    color: Color(0xFF0A0A50),
                    size: 20,
                  ),
                  onPressed: () {
                    // Add your navigation code here
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}