import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ihuriro/screens/auth/login.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/utils/text_utils.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          // height: 600,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          decoration: BoxDecoration(
            border: Border.all(color: primaryRed),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: ListView(
                  children: [
                    const Spacer(),
                    Center(
                      child: TextUtil(
                        text: "Register",
                        weight: true,
                        size: 30,
                      ),
                    ),
                    TextUtil(
                      text: "Name",
                    ),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextUtil(
                      text: "Email",
                    ),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.mail,
                          color: Colors.white,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextUtil(
                      text: "Password",
                    ),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextUtil(
                      text: "Confirm Password",
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        suffixIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        border: UnderlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: primaryRed,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: TextUtil(
                        text: "Register",
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextUtil(
                            text: "Already have an account? ",
                            size: 12,
                            weight: true,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return const Login();
                              }));
                            },
                            child: TextUtil(
                              text: "Login",
                              size: 14,
                              weight: true,
                              color: primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
