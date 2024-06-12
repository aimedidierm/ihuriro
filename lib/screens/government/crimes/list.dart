import 'package:flutter/material.dart';

class ListReportedCrimes extends StatefulWidget {
  const ListReportedCrimes({super.key});

  @override
  State<ListReportedCrimes> createState() => _ListReportedCrimesState();
}

class _ListReportedCrimesState extends State<ListReportedCrimes> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('Reported Crimes List'),
    );
  }
}
