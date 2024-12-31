import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mediscope/screens/detection/brain_tumor_screen.dart';
import 'package:mediscope/screens/welcome_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Hide the status bar and navigation bar globally across the app
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BrainTumorDetectionPage(),  // Home screen as the starting point
    );
  }
}
