import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/screens/auth/settings.dart';
import 'package:ihuriro/screens/law/dashboard/settings.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:http/http.dart' as http;

class LawDashboard extends StatefulWidget {
  const LawDashboard({super.key});

  @override
  State<LawDashboard> createState() => _LawDashboardState();
}

class _LawDashboardState extends State<LawDashboard> {
  bool loading = true;
  bool showReport = false;
  bool showReported = false;
  bool showSurveys = false;
  bool showUnread = false;
  int reports = 0, reported = 0, surveys = 0, unread = 0;

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(lawURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      setState(() {
        reports = decodedResponse['reports'];
        reported = decodedResponse['reported'];
        surveys = decodedResponse['surveys'];
        unread = decodedResponse['unread'];
        loading = false;
      });
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> fetchDashboardSettings() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(lawSettingsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body)['dashboard_details'];
      setState(() {
        showReport = decodedResponse['option_1'];
        showReported = decodedResponse['option_2'];
        showSurveys = decodedResponse['option_3'];
        showUnread = decodedResponse['option_4'];
      });
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDashboardSettings();
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
                        "Dashboard",
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
      body: loading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryRed,
              ),
            )
          : ListView(
              children: [
                showReport
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) {
                            //       return const ListReports();
                            //     },
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: primaryPink,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(width: 10),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.copy,
                                        color: primaryRed,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      reports.toString(),
                                      style: TextStyle(
                                        color: primaryRed,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Reports',
                                      style: TextStyle(
                                        color: primaryRed,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                showReported
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) {
                            //       return const ListReports();
                            //     },
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      reported.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Reported',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                showSurveys
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) {
                            //       return const ListReports();
                            //     },
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.format_align_center,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      surveys.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Surveys',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
                showUnread
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (BuildContext context) {
                            //       return const ListReports();
                            //     },
                            //   ),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.indigo,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 10),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Icon(
                                        Icons.message,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    ],
                                  ),
                                  Row(children: [
                                    Text(
                                      unread.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    const Text(
                                      'Unread',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 70,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LawDashboardSetting(),
                  ),
                );
              },
              child: Icon(
                Icons.dashboard_customize,
                color: primaryRed,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Settings(),
                  ),
                );
              },
              child: Icon(
                Icons.settings,
                color: primaryRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
