import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ihuriro/screens/loading.dart';
import 'package:ihuriro/screens/theme/colors.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Loading(),
        ),
        (route) => false,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: themeColor,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/icon.png',
                height: 80,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
