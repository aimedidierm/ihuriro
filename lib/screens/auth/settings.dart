// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/screens/auth/login.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:ihuriro/services/user.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  List<Map<String, dynamic>> _userDetails = [];
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool loadingData = true;
  bool loadingButton = false;

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(settingsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<Map<String, dynamic>> userDetails = [decodedResponse['user']];

      setState(() {
        _userDetails = userDetails;
        loadingData = false;
      });

      if (_userDetails.isNotEmpty) {
        name.text = _userDetails[0]['name'];
        email.text = _userDetails[0]['email'];
      }
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  }

  void updateUser() async {
    ApiResponse response = await updateDetails(
      name.text,
      email.text,
      password.text,
    );
    if (response.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Details updated!'),
        ),
      );
      setState(() {
        loadingButton = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${response.error}'),
        ),
      );
      setState(() {
        loadingButton = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipPath(
          clipper: AppBarClipPath(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryRed, primaryRed.withOpacity(0.9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const Text(
                        'Account Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: loadingData
          ? Center(
              child: CircularProgressIndicator(
                color: primaryRed,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 80,
                          ),
                          Form(
                            key: formkey,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: name,
                                    validator: (val) => val!.isEmpty
                                        ? 'Names are required'
                                        : null,
                                    decoration: InputDecoration(
                                      labelText: 'Enter names',
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: primaryRed,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: email,
                                    validator: (val) {
                                      RegExp regex = RegExp(r'\w+@\w+\.\w+');
                                      if (val!.isEmpty) {
                                        return 'Email is required';
                                      } else if (!regex.hasMatch(val)) {
                                        return 'Invalid email';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Enter email',
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: primaryRed,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    controller: password,
                                    obscureText: true,
                                    validator: (val) => val!.isEmpty
                                        ? 'Password is required'
                                        : null,
                                    decoration: InputDecoration(
                                      labelText: 'Enter password',
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: primaryRed,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextFormField(
                                    obscureText: true,
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return 'You must confirm password';
                                      } else if (val != password.text) {
                                        return 'Passpords not match';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Confirm password',
                                      contentPadding: const EdgeInsets.all(8.0),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: primaryRed,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (formkey.currentState!.validate()) {
                                        setState(() {
                                          loadingButton = true;
                                        });
                                        updateUser();
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateColor.resolveWith(
                                        (states) => primaryRed,
                                      ),
                                      padding:
                                          MaterialStateProperty.resolveWith(
                                        (states) => const EdgeInsets.symmetric(
                                            vertical: 10),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: loadingButton
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                          : const Text(
                                              'Update details',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            logout().then(
              (value) => {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const Login()),
                  (route) => false,
                ),
              },
            );
          },
          child: Icon(
            Icons.logout,
            color: primaryRed,
          ),
        ),
      ),
    );
  }
}
