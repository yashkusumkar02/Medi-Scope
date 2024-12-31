import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscope/screens/detection/brain_tumor_screen.dart';
import 'package:mediscope/screens/detection/lung_cancer_screen.dart';
import 'package:mediscope/screens/detection/skin_cancer_screen.dart';
import 'package:mediscope/widgets/CovidDiseaseDetection.dart';
import 'package:mediscope/widgets/DetectionCard.dart';
import 'package:mediscope/widgets/HealthCalculator.dart';
import 'package:mediscope/widgets/LungCancerWidget.dart';
import 'package:mediscope/widgets/SkinCancerWidget.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current hour to decide the greeting
    int currentHour = DateTime.now().hour;
    String greeting = '';
    String description = '';

    if (currentHour >= 5 && currentHour < 12) {
      greeting = 'Good Morning';
      description = 'We wish you have a great day ahead!';
    } else if (currentHour >= 12 && currentHour < 17) {
      greeting = 'Good Afternoon';
      description = 'Hope your day is going well!';
    } else {
      greeting = 'Good Evening';
      description = 'Wishing you a relaxing evening!';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting Message and Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Greeting message and description on the left
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF864A17),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF47484F),
                          ),
                        ),
                      ],
                    ),

                    // Logo inside a circle on the right
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Color(0xFF8E97FD), // Circle color
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50), // Space between greeting and card

                // Detection Card with left and right padding
                DetectionCard(
                  title: 'Brain Tumor',
                  subtitle: 'Detection',
                  backgroundImagePath: 'assets/images/brain_tumor_background.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BrainTumorDetectionPage(), // Replace with actual widget
                      ),
                    );
                  },
                ),

                SizedBox(height: 20), // Space between the detection card and health calculator

                // Health Calculator widget
                HealthCalculatorWidget(),

                SizedBox(height: 20),

                // Row to display both Skin Cancer and Lung Cancer widgets side by side
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Skin Cancer Detection Widget
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap action for Skin Cancer Detection
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SkinCancerDetectionPage(), // Replace with the actual page for Skin Cancer Detection
                            ),
                          );
                        },
                        child: SkinCancerDetectionWidget(),
                      ),
                    ),

                    // Lung Cancer Detection Widget
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Handle tap action for Lung Cancer Detection
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LungcancerDetectionPage(), // Replace with the actual page for Lung Cancer Detection
                            ),
                          );
                        },
                        child: LungCancerDetectionWidget(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20), // Space between the detection card and health calculator

                // Covid Disease Detection widget
                Coviddiseasedetection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
