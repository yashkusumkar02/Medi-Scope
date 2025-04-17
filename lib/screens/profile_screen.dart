import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mediscope/screens/splash_screen.dart';

import 'UpdateProfileScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String phone = '';
  String name = '';
  bool isLoading = true;

  final nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      phone = user.phoneNumber ?? 'Unknown';

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data();
        name = data?['name'] ?? '';
        nameController.text = name;
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> saveUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': nameController.text.trim(),
        'phone': user.phoneNumber,
        'joined': Timestamp.now(),
      });

      setState(() {
        name = nameController.text.trim();
      });

      // 🎉 Show welcome popup
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Lottie.asset('assets/animation/success.json'),
              ),
              const SizedBox(height: 20),
              Text(
                'Wow!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF864A17),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You have added your profile successfully.\nYou can now use this app.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF864A17),
                ),
                child: Text(
                  'Continue',
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
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF864A17),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Image
            const Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/profilescreen.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.edit, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show phone number and name input
            Text(
              phone,
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 8),

            name.isEmpty
                ? Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Enter your name'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: saveUserData,
                  child: Text("Save", style: GoogleFonts.poppins()),
                ),
              ],
            )
                : Column(
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => UpdateProfileScreen(name: name));
                  },
                  child: Text("Edit Profile", style: GoogleFonts.poppins()),
                ),
              ],
            ),

            const Divider(height: 40),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text("Profile", style: GoogleFonts.poppins()),
              onTap: () {
                Get.to(() => UpdateProfileScreen(name: name));
              },
            ),
            ListTile(
              leading: const Icon(Icons.policy),
              title: Text("Privacy Policy", style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text("Help", style: GoogleFonts.poppins()),
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(
                "Logout",
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              onTap: () {
                Get.defaultDialog(
                  title: "Logout",
                  content: const Text("Are you sure you want to logout?"),
                  confirm: ElevatedButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Get.to(SplashScreen());
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Yes"),
                  ),
                  cancel: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: const Text("No"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
