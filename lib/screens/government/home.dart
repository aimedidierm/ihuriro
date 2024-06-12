import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:ihuriro/screens/theme/colors.dart';

class GovernmentHome extends StatefulWidget {
  const GovernmentHome({super.key});

  @override
  State<GovernmentHome> createState() => _GovernmentHomeState();
}

class _GovernmentHomeState extends State<GovernmentHome> {
  int _selectedIndex = 0;
  static List<Widget> page = [
    const Center(child: Text('Dashboard')),
    const Center(child: Text('Chat')),
    const Center(child: Text('Crimes')),
    const Center(child: Text('Survey')),
    const Center(child: Text('Map')),
    const Center(child: Text('Resources')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: page[_selectedIndex],
      bottomNavigationBar: Container(
        color: primaryRed,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: GNav(
              backgroundColor: primaryRed,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.white38,
              gap: 10,
              padding: const EdgeInsets.all(10),
              duration: const Duration(milliseconds: 400),
              tabBorderRadius: 10,
              tabs: const [
                GButton(
                  icon: Icons.dashboard,
                  text: 'Dashboard',
                ),
                GButton(
                  icon: Icons.message,
                  text: 'Chat',
                ),
                GButton(
                  icon: Icons.copy,
                  text: 'Crimes',
                ),
                GButton(
                  icon: Icons.format_align_center,
                  text: 'Survey',
                ),
                GButton(
                  icon: Icons.location_on,
                  text: 'Map',
                ),
                GButton(
                  icon: Icons.folder,
                  text: 'Resources',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
