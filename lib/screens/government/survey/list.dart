import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/screens/government/survey/details.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:ihuriro/services/auth.dart';
import 'package:intl/intl.dart';

class ListSurveys extends StatefulWidget {
  const ListSurveys({super.key});

  @override
  State<ListSurveys> createState() => _ListSurveysState();
}

class _ListSurveysState extends State<ListSurveys> {
  bool _loading = true;

  List<Map<String, dynamic>> _allSurveys = [];

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);

    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

    return formattedDate;
  }

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(governmentSurveysURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<dynamic> decodedSurveys = decodedResponse['surveys'];
      final List<Map<String, dynamic>> surveys =
          List<Map<String, dynamic>>.from(decodedSurveys);
      setState(() {
        _allSurveys = surveys;
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
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 10),
                      Text(
                        "Surveys",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryRed,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _allSurveys.length,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(index),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                _allSurveys[index]['user']['name'],
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) {
                                      return SurveyDetails(
                                        q1: _allSurveys[index]['q1'],
                                        q2: _allSurveys[index]['q2'],
                                        q3: _allSurveys[index]['q3'],
                                        q4: _allSurveys[index]['q4'],
                                        q5: _allSurveys[index]['q5'],
                                        q6: _allSurveys[index]['q6'],
                                        q7: _allSurveys[index]['q7'],
                                        user: _allSurveys[index]['user']
                                            ['name'],
                                        email: _allSurveys[index]['user']
                                            ['email'],
                                      );
                                    },
                                  ),
                                );
                              },
                              subtitle: Text(
                                formatDate(_allSurveys[index]['created_at']),
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
