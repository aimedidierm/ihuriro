import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:http/http.dart' as http;

class SurveyDetails extends StatefulWidget {
  final String q1, q2, q3, q4, q5, q6, q7;
  const SurveyDetails({
    Key? key,
    required this.q1,
    required this.q2,
    required this.q3,
    required this.q4,
    required this.q5,
    required this.q6,
    required this.q7,
  }) : super(key: key);

  @override
  State<SurveyDetails> createState() => _SurveyDetailsState();
}

class _SurveyDetailsState extends State<SurveyDetails> {
  bool _loading = true;

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
                        'Survey Details',
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
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryRed,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      Text(
                        "Answer: ${widget.q1}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
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
                      Text(
                        "Answer: ${widget.q2}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
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
                      Text(
                        "Answer: ${widget.q3}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
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
                      Text(
                        "Answer: ${widget.q4}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
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
                      Text(
                        "Answer: ${widget.q5}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
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
                      Text(
                        "Answer: ${widget.q6}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
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
                      Text(
                        "Answer: ${widget.q7}",
                        textAlign: TextAlign.justify,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
