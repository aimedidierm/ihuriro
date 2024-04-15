import 'package:flutter/material.dart';

class GovernmentHome extends StatefulWidget {
  const GovernmentHome({super.key});

  @override
  State<GovernmentHome> createState() => _GovernmentHomeState();
}

class _GovernmentHomeState extends State<GovernmentHome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Government Home'),
      ),
    );
  }
}
