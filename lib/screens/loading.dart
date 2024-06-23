// ignore_for_file: use_build_context_synchronously

import 'package:ihuriro/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:ihuriro/screens/government/home.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/services/auth.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getUserInfo() async {
    String token = await getToken();
    if (token == '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
        (route) => false,
      );
    } else {
      String role = await getRole();
      if (role == "government") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const GovernmentHome(),
            ),
            (route) => false);
      } else {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
          (route) => false,
        );
      }
    }
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryRed,
      body: const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
    );
  }
}
