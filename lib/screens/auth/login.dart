// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/models/user.dart';
import 'package:ihuriro/screens/auth/register.dart';
import 'package:ihuriro/screens/government/home.dart';
import 'package:ihuriro/screens/law/home.dart';
import 'package:ihuriro/screens/report/anonymous.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/user/home.dart';
import 'package:ihuriro/screens/utils/text_utils.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _loading = false;

  void _saveAndRedirect(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setString('role', user.role ?? '');
    await pref.setInt('userId', (user.id ?? 0));
  }

  void loginUser() async {
    ApiResponse response = await login(email.text, password.text);
    if (response.error == null) {
      _saveAndRedirect(response.data as User);
      User user = response.data as User;
      if (user.role == "government") {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const GovernmentHome(),
            ),
            (route) => false);
      } else {
        if (user.role == "law") {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const LawHome(),
              ),
              (route) => false);
        } else {
          if (user.role == "user") {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const UserHome(),
                ),
                (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid role'),
              ),
            );
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
                (route) => false);
          }
        }
      }
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
              image: AssetImage('assets/images/bg.jpg'), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Container(
          height: 460,
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
                child: Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: TextUtil(
                          text: "Login",
                          weight: true,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextUtil(
                        text: "Email",
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: TextFormField(
                          controller: email,
                          validator: (val) =>
                              val!.isEmpty ? 'Email is required' : null,
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
                      const SizedBox(height: 10),
                      TextUtil(
                        text: "Password",
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: TextFormField(
                          controller: password,
                          obscureText: true,
                          validator: (val) =>
                              val!.isEmpty ? 'Password is required' : null,
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
                      const SizedBox(height: 30),
                      Expanded(
                        child: TextUtil(
                          text: "FORGET PASSWORD",
                          size: 12,
                          weight: true,
                        ),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          if (formkey.currentState!.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            loginUser();
                          }
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
      ),
    );
  }
}
