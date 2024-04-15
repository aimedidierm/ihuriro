import 'package:flutter/material.dart';

class LawHome extends StatefulWidget {
  const LawHome({super.key});

  @override
  State<LawHome> createState() => _LawHomeState();
}

class _LawHomeState extends State<LawHome> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Law Home'),
      ),
    );
  }
}
