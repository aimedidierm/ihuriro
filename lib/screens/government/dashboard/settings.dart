import 'package:flutter/material.dart';

class GovernmentDashboardSetting extends StatefulWidget {
  const GovernmentDashboardSetting({super.key});

  @override
  State<GovernmentDashboardSetting> createState() =>
      _GovernmentDashboardSettingState();
}

class _GovernmentDashboardSettingState
    extends State<GovernmentDashboardSetting> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('G Dashboard Settings'),
    );
  }
}
