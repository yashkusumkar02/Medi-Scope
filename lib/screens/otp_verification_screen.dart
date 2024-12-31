import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator
import 'package:google_fonts/google_fonts.dart';
import 'package:mediscope/screens/welcome_screen.dart';

class OtpVerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Getting screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Close the app when the back button is pressed or slide back
        SystemNavigator.pop();
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        body: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Color(0xFF864A17), Color(0xFF7C3229)],
            ),
          ),
          child: Stack(
            children: [
              // Image at the top with slight overlay
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: screenHeight * 0.45, // Adjusted height for the image
                  child: Center(
                    child: Image.asset(
                      'assets/images/person.png', // Image file path
                      fit: BoxFit.cover,
                      width: screenWidth * 0.7, // Adjust the width
                    ),
                  ),
                ),
              ),

              // White Box with the OTP verification information
              Positioned(
                top: screenHeight * 0.35, // Starts slightly overlapping the image
                left: 0,
                right: 0,
                bottom: 0, // Ensures it stretches to the bottom
                child: Container(
                  width: screenWidth,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF6F2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // OTP Verification Header
                      const SizedBox(height: 40),
                      Center(
                        child: Text(
                          'OTP Verification',
                          style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF864A17),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Enter OTP Received in Your System...',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF864A17),
                          ),
                        ),
                      ),
                      SizedBox(height: 40), // Spacing

                      // OTP Input (Four boxes for OTP)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color(0xFF864A17), width: 2),
                            ),
                            child: Center(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '',
                                  hintStyle: TextStyle(color: Color(0xFF864A17)),
                                ),
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF864A17),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      SizedBox(height: 40), // Spacing

                      // Submit Button
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => WelcomeScreen()),
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.80,
                            height: 49,
                            decoration: ShapeDecoration(
                              gradient: LinearGradient(
                                begin: Alignment(0.00, -1.00),
                                end: Alignment(0, 1),
                                colors: [Color(0xFF864A17), Color(0xFF7C3229)],
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Color(0xFFFFF6F2),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
