import 'package:flutter/material.dart';

class GovernmentDashboard extends StatefulWidget {
  const GovernmentDashboard({super.key});

  @override
  State<GovernmentDashboard> createState() => _GovernmentDashboardState();
}

class _GovernmentDashboardState extends State<GovernmentDashboard> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Dashboard'),
    );
  }
}
