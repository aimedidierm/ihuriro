// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/law_users.dart';

class CreateLawUser extends StatefulWidget {
  const CreateLawUser({super.key});

  @override
  State<CreateLawUser> createState() => _CreateLawUserState();
}

class _CreateLawUserState extends State<CreateLawUser> {
  bool _loading = false;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  void registerUser() async {
    ApiResponse response = await register(
      name.text,
      email.text,
    );
    if (response.error == null) {
      setState(() {
        _loading = false;
        name.text = '';
        email.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered'),
        ),
      );
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
                        'Create Law User',
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
      body: ListView(
        children: [
          const SizedBox(
            height: 40,
          ),
          Form(
            key: formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Names are required';
                      } else {
                        return null;
                      }
                    },
                    controller: name,
                    decoration: const InputDecoration(
                      hintText: 'Enter names',
                      labelText: 'names',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Email is required';
                      } else {
                        return null;
                      }
                    },
                    controller: email,
                    decoration: const InputDecoration(
                      hintText: 'Enter email',
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        setState(() {
                          _loading = true;
                        });
                        registerUser();
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith(
                        (states) => primaryRed,
                      ),
                      padding: MaterialStateProperty.resolveWith(
                        (states) => const EdgeInsets.symmetric(vertical: 20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: (_loading)
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Create User',
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
        ],
      ),
    );
  }
}
