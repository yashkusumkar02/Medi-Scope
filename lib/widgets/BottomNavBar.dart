import 'package:flutter/material.dart';
import 'package:mediscope/screens/history_screen.dart';
import 'package:mediscope/screens/home_screen.dart';
import 'package:mediscope/screens/profile_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class BottomNavScreen extends StatefulWidget {
  @override
  _BottomNavScreenState createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  // Initialize the PersistentTabController
  final PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  // List of screens to navigate between
  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      HistoryScreen(),
      ProfileScreen(),
    ];
  }

  // Bottom navigation bar items
  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history),
        title: ("History"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        screens: _buildScreens(),
        controller: _controller,
        items: _navBarsItems(),
        navBarHeight: 70.0,
        confineToSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        decoration: NavBarDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10.0,
              offset: Offset(0, -2),
            ),
          ],
        ),
        onItemSelected: (index) {
          // Optionally handle selection logic here, e.g., logging or page transitions
          setState(() {
            _controller.index = index;
          });
        },
      )
    );
  }
}
