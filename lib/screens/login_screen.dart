import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart'; // Import for SystemNavigator
import 'otp_verification_screen.dart'; // Import the OTP verification screen

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Getting screen width and height using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        // Close the app and restart when the back button is pressed
        SystemNavigator.pop(); // This will close the app
        return false; // Prevent the default back button behavior
      },
      child: Scaffold(
        body: SingleChildScrollView(  // Wrap the entire body in a SingleChildScrollView
          child: Container(
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

                // White Box with the login information
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
                        // Welcome Text
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            'Welcome!',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF864A17),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Login with OTP Based System',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF864A17),
                            ),
                          ),
                        ),
                        SizedBox(height: 40), // Spacing

                        // Mobile Number Input with Country Code
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Color(0xFF864A17), width: 3),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Fixed Country Code +91
                              Text(
                                '+91',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFFB6841B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Divider Line between +91 and mobile number
                              Container(
                                height: 24,
                                width: 1,
                                color: Color(0xFFB6841B),
                              ),
                              const SizedBox(width: 8),
                              // Phone Number TextField
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Enter Mobile Number',
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.poppins(
                                      color: Color(0xFFB6841B),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  keyboardType: TextInputType.phone,
                                  style: GoogleFonts.poppins(
                                    color: Color(0xFFB6841B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40), // Spacing

                        // 'Next' Button
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to OTP Verification Screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OtpVerificationScreen(),
                                ),
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
                                  'Next',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFFFF6F2),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 40), // Space for button
                      ],
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
