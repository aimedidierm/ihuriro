// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:ihuriro/services/survey.dart';

class CreateSurvey extends StatefulWidget {
  const CreateSurvey({super.key});

  @override
  State<CreateSurvey> createState() => _CreateSurveyState();
}

class _CreateSurveyState extends State<CreateSurvey> {
  bool _loading = true;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController q1 = TextEditingController();
  TextEditingController q2 = TextEditingController();
  TextEditingController q3 = TextEditingController();
  TextEditingController q4 = TextEditingController();
  TextEditingController q5 = TextEditingController();
  TextEditingController q6 = TextEditingController();
  TextEditingController q7 = TextEditingController();

  List<Map<String, dynamic>> _allQuestions = [];

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(questionsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<dynamic> decodedQuestions = decodedResponse['questions'];
      final List<Map<String, dynamic>> questions =
          List<Map<String, dynamic>>.from(decodedQuestions);
      setState(() {
        _allQuestions = questions;
        _loading = false;
      });
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  }

  void saveSurvey() async {
    ApiResponse response = await registerSurvey(
      q1.text,
      q2.text,
      q3.text,
      q5.text,
      q1.text,
      q6.text,
      q7.text,
    );
    if (response.error == null) {
      setState(() {
        _loading = false;
        q1.text = '';
        q2.text = '';
        q3.text = '';
        q4.text = '';
        q5.text = '';
        q6.text = '';
        q7.text = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Survey reported'),
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
              color: primaryRed,
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
                        "Create survey",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryRed,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Form(
                key: formkey,
                child: ListView(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q1. ${_allQuestions[0]['q1']}",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Answer is required';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          controller: q1,
                          decoration: const InputDecoration(
                            hintText: 'Enter Answer',
                            labelText: 'Answer',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q2. ${_allQuestions[0]['q2']}",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Answer is required';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          controller: q2,
                          decoration: const InputDecoration(
                            hintText: 'Enter Answer',
                            labelText: 'Answer',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q3. ${_allQuestions[0]['q3']}",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Answer is required';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          controller: q3,
                          decoration: const InputDecoration(
                            hintText: 'Enter Answer',
                            labelText: 'Answer',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q4. ${_allQuestions[0]['q4']}",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Answer is required';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          controller: q4,
                          decoration: const InputDecoration(
                            hintText: 'Enter Answer',
                            labelText: 'Answer',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q5. ${_allQuestions[0]['q5']}",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Answer is required';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          controller: q5,
                          decoration: const InputDecoration(
                            hintText: 'Enter Answer',
                            labelText: 'Answer',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q6. ${_allQuestions[0]['q6']}",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Answer is required';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          controller: q6,
                          decoration: const InputDecoration(
                            hintText: 'Enter Answer',
                            labelText: 'Answer',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q7. ${_allQuestions[0]['q7']}",
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Answer is required';
                            } else {
                              return null;
                            }
                          },
                          maxLines: null,
                          controller: q7,
                          decoration: const InputDecoration(
                            hintText: 'Enter Answer',
                            labelText: 'Answer',
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
                              saveSurvey();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                              (states) => primaryRed,
                            ),
                            padding: MaterialStateProperty.resolveWith(
                              (states) =>
                                  const EdgeInsets.symmetric(vertical: 20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: (_loading)
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text(
                                    'Create',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
