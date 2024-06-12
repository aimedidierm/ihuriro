import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/screens/auth/register.dart';
import 'package:ihuriro/screens/government/home.dart';
import 'package:ihuriro/screens/report/anonymous.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/utils/text_utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _loading = false;

  void loginUser() async {
    // ApiResponse response = await login(email.text, password.text);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const GovernmentHome(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 400,
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 30),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Center(
                      child: TextUtil(
                        text: "Login",
                        weight: true,
                        size: 30,
                      ),
                    ),
                    const Spacer(),
                    TextUtil(
                      text: "Email",
                    ),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.white))),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.mail,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextUtil(
                      text: "Password",
                    ),
                    Container(
                      height: 35,
                      decoration: const BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.white))),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: TextUtil(
                        text: "FORGET PASSWORD",
                        size: 12,
                        weight: true,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // if (formkey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        loginUser();
                        // }
                      },
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: primaryRed,
                            borderRadius: BorderRadius.circular(30)),
                        alignment: Alignment.center,
                        child: _loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : TextUtil(
                                text: "Log In",
                                color: Colors.white,
                              ),
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Row(
                        children: [
                          TextUtil(
                            text: "Don't have a account ",
                            size: 12,
                            weight: true,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return const Register();
                              }));
                            },
                            child: TextUtil(
                              text: "REGISTER",
                              size: 14,
                              weight: true,
                              color: primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return const Anonymous();
                            }));
                          },
                          child: TextUtil(
                            text: "Anonymous Reporting",
                            size: 14,
                            weight: true,
                            color: primaryRed,
                          ),
                        ),
                      ],
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
