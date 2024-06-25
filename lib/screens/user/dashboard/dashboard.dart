import 'package:flutter/material.dart';
import 'package:ihuriro/screens/auth/settings.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/user/dashboard/settings.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipPath(
          clipper: AppBarClipPath(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryRed, primaryRed.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: CircularProgressIndicator(
          color: primaryRed,
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 70,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserDashboardSettings(),
                  ),
                );
              },
              child: Icon(
                Icons.dashboard_customize,
                color: primaryRed,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
              child: Icon(
                Icons.settings,
                color: primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
