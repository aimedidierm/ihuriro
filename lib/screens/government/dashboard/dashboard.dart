import 'package:flutter/material.dart';
import 'package:ihuriro/screens/government/dashboard/settings.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';

class GovernmentDashboard extends StatefulWidget {
  const GovernmentDashboard({super.key});

  @override
  State<GovernmentDashboard> createState() => _GovernmentDashboardState();
}

class _GovernmentDashboardState extends State<GovernmentDashboard> {
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
      body: const Center(child: Text('Dashboard')),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GovernmentDashboardSetting(),
                ),
              );
            },
            child: Icon(
              Icons.dashboard_customize,
              color: primaryRed,
            )),
      ),
    );
  }
}
