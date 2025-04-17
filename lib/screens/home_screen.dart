import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mediscope/screens/detection/brain_tumor_screen.dart';
import 'package:mediscope/screens/detection/lung_cancer_screen.dart';
import 'package:mediscope/screens/detection/skin_cancer_screen.dart';
import 'package:mediscope/widgets/CovidDiseaseDetection.dart';
import 'package:mediscope/widgets/DetectionCard.dart';
import 'package:mediscope/widgets/HealthCalculator.dart';
import 'package:mediscope/widgets/LungCancerWidget.dart';
import 'package:mediscope/widgets/SkinCancerWidget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  final PersistentTabController controller;
  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool hasProfileData = true;

  @override
  void initState() {
    super.initState();
    checkProfileDetails();
  }

  Future<void> checkProfileDetails() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final data = doc.data();

      final name = data?['name'];
      final email = data?['email'];

      if (name == null || name.toString().isEmpty || email == null || email.toString().isEmpty) {
        setState(() => hasProfileData = false);
        showProfileReminderPopup();
      }
    }
  }

  void showProfileReminderPopup() {
    Future.delayed(const Duration(milliseconds: 500), () {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/animation/profile_warning.json',
                width: 180,
                height: 180,
              ),
              const SizedBox(height: 15),
              Text(
                "Profile Incomplete!",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Please complete your profile details to use this app properly.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF864A17),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop(); // ✅ Close the popup first
                  Future.delayed(Duration(milliseconds: 300), () {
                    widget.controller.jumpToTab(3); // ✅ Then jump to Profile tab
                  });
                },
                child: Text(
                  "Go to Profile",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF864A17),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF47484F),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8E97FD),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
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
                const SizedBox(height: 50),
                DetectionCard(
                  title: 'Brain Tumor',
                  subtitle: 'Detection',
                  backgroundImagePath: 'assets/images/brain_tumor_background.png',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BrainTumorDetectionPage()),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const HealthCalculatorWidget(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SkinCancerDetectionPage()),
                          );
                        },
                        child: const SkinCancerDetectionWidget(),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LungcancerDetectionPage()),
                          );
                        },
                        child: const LungCancerDetectionWidget(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Coviddiseasedetection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}