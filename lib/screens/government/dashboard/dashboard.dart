import 'package:flutter/material.dart';
import 'package:ihuriro/screens/government/dashboard/settings.dart';
import 'package:ihuriro/screens/theme/colors.dart';

class GovernmentDashboard extends StatefulWidget {
  const GovernmentDashboard({super.key});

  @override
  State<GovernmentDashboard> createState() => _GovernmentDashboardState();
}

class _GovernmentDashboardState extends State<GovernmentDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
