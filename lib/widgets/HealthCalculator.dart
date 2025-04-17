import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/HealthCalculator.dart'; // Import BMI Calculator Page

class HealthCalculatorWidget extends StatelessWidget {
  const HealthCalculatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    void navigateToBMICalculator() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HealthCalculatorPage()),
      );
    }

    return GestureDetector(
      onTap: navigateToBMICalculator, // Navigate when tapping anywhere on the widget
      child: Container(
        width: screenWidth * 0.9,
        height: screenHeight * 0.12,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/images/health_calculator_background.png'),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 20,
              top: 35,
              child: Text(
                'Health',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Positioned(
              left: 20,
              top: 65,
              child: Text(
                'CALCULATOR',
                style: GoogleFonts.poppins(
                  color: const Color(0xFFEBEAEC),
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.55,
                ),
              ),
            ),
            Positioned(
              right: 20,
              top: 75,
              child: GestureDetector(
                onTap: navigateToBMICalculator, // Navigate when clicking TRY NOW
                child: Text(
                  'TRY NOW',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFFEBEAEC),
                    fontSize: screenWidth * 0.03,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.55,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: 20,
              child: GestureDetector(
                onTap: navigateToBMICalculator, // Navigate when clicking the button
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Color(0xFF0A0A50),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
