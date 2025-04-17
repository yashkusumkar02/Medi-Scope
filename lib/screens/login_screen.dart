import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _sendOtp() async {
    String phoneNumber = "+91${_phoneController.text.trim()}";

    if (_phoneController.text.trim().isEmpty || _phoneController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid 10-digit phone number'),
      ));
      return;
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        // Auto-complete (optional)
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification failed: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
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
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: screenHeight * 0.45,
                    child: Center(
                      child: Image.asset(
                        'assets/images/person.png',
                        fit: BoxFit.cover,
                        width: screenWidth * 0.7,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: screenHeight * 0.35,
                  left: 0,
                  right: 0,
                  bottom: 0,
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
                        const SizedBox(height: 40),
                        Center(
                          child: Text(
                            'Welcome!',
                            style: GoogleFonts.poppins(
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF864A17),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            'Login with OTP Based System',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF864A17),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFF864A17), width: 3),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Text(
                                '+91',
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFB6841B),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                height: 24,
                                width: 1,
                                color: const Color(0xFFB6841B),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  maxLength: 10, // ✅ Limit input to 10 digits
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    counterText: '', // hides character count
                                    hintText: 'Enter Mobile Number',
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.poppins(
                                      color: const Color(0xFFB6841B),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFB6841B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: _sendOtp,
                            child: Container(
                              width: screenWidth * 0.80,
                              height: 49,
                              decoration: ShapeDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment(0.00, -1.00),
                                  end: Alignment(0, 1),
                                  colors: [Color(0xFF864A17), Color(0xFF7C3229)],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Center(
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
                        const SizedBox(height: 40),
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
