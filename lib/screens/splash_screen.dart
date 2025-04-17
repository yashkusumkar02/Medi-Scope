import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscope/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // Adjust delay as needed
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF864B17),
              Color(0xFF7C3329),
            ],
          ),
        ),
        child: Column(
          children: [
            const Spacer(flex: 10), // Space at the top
            Image.asset(
              'assets/images/logo.png', // Replace with your logo path
              width: 100, // Adjust logo width as needed
              height: 100,
            ),
            const SizedBox(height: 40),
            Text(
              'MediScope',
              style: GoogleFonts.poppins(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Spacer(flex: 2),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const Spacer(flex: 2)// Space below the content
          ],
        ),
      ),
    );
  }
}
