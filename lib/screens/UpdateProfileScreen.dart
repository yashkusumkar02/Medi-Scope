import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UpdateProfileScreen extends StatefulWidget {
  final String name;
  const UpdateProfileScreen({super.key, required this.name});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  String phone = '';
  String joinedDate = '';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      phone = user.phoneNumber ?? '';

      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        nameController.text = data?['name'] ?? '';
        emailController.text = data?['email'] ?? '';
        Timestamp? joined = data?['joined'];
        joinedDate = joined != null ? DateFormat('dd MMM yyyy').format(joined.toDate()) : '';
      } else {
        nameController.text = widget.name;
        joinedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
      }

      setState(() {});
    }
  }

  Future<void> updateProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      Get.back();
    }
  }

  Future<void> deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();
      await user.delete();

      Get.offAllNamed('/login'); // Or your login route
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF864A17),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
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
                    child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      labelStyle: GoogleFonts.poppins(),
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: GoogleFonts.poppins(),
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      TextFormField(
                        enabled: false,
                        initialValue: phone,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: GoogleFonts.poppins(),
                          prefixIcon: const Icon(Icons.phone),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const Positioned(
                        right: 12,
                        child: Icon(
                          Icons.verified,
                          color: Colors.green,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: updateProfile,
                      child: Text(
                        "Save Changes",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Joined: ",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                              text: joinedDate,
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.defaultDialog(
                            title: "Delete Account",
                            content: const Text("Are you sure you want to delete your account?"),
                            confirm: ElevatedButton(
                              onPressed: deleteAccount,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text("Yes"),
                            ),
                            cancel: OutlinedButton(
                              onPressed: () => Get.back(),
                              child: const Text("No"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.withOpacity(0.1),
                          foregroundColor: Colors.red,
                        ),
                        child: Text(
                          "Delete Account",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
