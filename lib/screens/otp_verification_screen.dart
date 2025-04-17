import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mediscope/screens/welcome_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verificationId;
  const OtpVerificationScreen({super.key, required this.verificationId});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late List<TextEditingController> _otpControllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    // ✅ Ensure exactly 6 controllers and 6 focus nodes
    _otpControllers = List.generate(6, (_) => TextEditingController());
    _focusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    String otpCode = _otpControllers.map((c) => c.text.trim()).join();
    if (otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the full 6-digit OTP')),
      );
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP Verified Successfully')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("OTP verification failed: ${e.toString()}")),
      );
    }
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
                    children: [
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
                      const SizedBox(height: 40),
                      Row(
                        children: List.generate(6, (index) {
                          return Expanded(
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFF864A17), width: 2),
                              ),
                              child: Center(
                                child: TextField(
                                  controller: _otpControllers[index], // ✅ No out-of-range
                                  focusNode: _focusNodes[index],      // ✅ No out-of-range
                                  maxLength: 1,
                                  decoration: const InputDecoration(
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF864A17),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty && index < 5) {
                                      _focusNodes[index + 1].requestFocus();
                                    } else if (value.isEmpty && index > 0) {
                                      _focusNodes[index - 1].requestFocus();
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 40),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: _verifyOtp,
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
                            child: Center(
                              child: Text(
                                'Submit',
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
