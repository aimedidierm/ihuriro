// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/screens/auth/login.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/utils/text_utils.dart';
import 'package:ihuriro/services/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _loading = false;
  final formkey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void registerUser() async {
    ApiResponse response = await register(
      _nameController.text,
      _emailController.text,
    );
    if (response.error == null) {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created'),
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const Login(),
          ),
          (route) => false);
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
    }
  }

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
          height: 460,
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
              child: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
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
                        text: "Names",
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: (val) =>
                            val!.isEmpty ? 'Names is required' : null,
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
                        validator: (val) =>
                            val!.isEmpty ? 'Email is required' : null,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                          border: UnderlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            registerUser();
                          }
                        },
                        child: Container(
                          height: 40,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : TextUtil(
                                  text: "Register",
                                  color: Colors.white,
                                ),
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
      ),
    );
  }
}
