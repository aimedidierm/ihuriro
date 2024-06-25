// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:ihuriro/services/auth.dart';
import 'package:http/http.dart' as http;

class UserDashboardSettings extends StatefulWidget {
  const UserDashboardSettings({super.key});

  @override
  State<UserDashboardSettings> createState() => _UserDashboardSettingsState();
}

class _UserDashboardSettingsState extends State<UserDashboardSettings> {
  bool _loading = false;
  bool loadingContent = true;
  bool showReport = false;
  bool showReported = false;
  bool showSurveys = false;
  bool showUnread = false;
  int dashboardId = 0;

  void updateDashboard(
    bool option1,
    bool option2,
    bool option3,
    bool option4,
  ) async {
    String token = await getToken();
    final response =
        await http.put(Uri.parse('$userSettingsURL/$dashboardId'), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'option_1': option1.toString(),
      'option_2': option2.toString(),
      'option_3': option3.toString(),
      'option_4': option4.toString(),
    });

    switch (response.statusCode) {
      case 200:
        Navigator.of(context).pop();
        setState(() {
          _loading = false;
        });
        break;
      case 401:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${jsonDecode(response.body)['message']}'),
          ),
        );
        setState(() {
          _loading = false;
        });
        break;
      case 422:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${jsonDecode(response.body)['message']}'),
          ),
        );
        setState(() {
          _loading = false;
        });
        break;
      case 403:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${jsonDecode(response.body)['message']}'),
          ),
        );
        setState(() {
          _loading = false;
        });
        break;
      case 500:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Internal server error'),
          ),
        );
        setState(() {
          _loading = false;
        });
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong'),
          ),
        );
        break;
    }
  }

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(userSettingsURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body)['dashboard_details'];
      setState(() {
        dashboardId = decodedResponse['id'];
        showReport = decodedResponse['option_1'];
        showReported = decodedResponse['option_2'];
        showSurveys = decodedResponse['option_3'];
        showUnread = decodedResponse['option_4'];
        loadingContent = false;
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
                        'Customize Dashboard',
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
      body: loadingContent
          ? Center(child: CircularProgressIndicator(color: primaryRed))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                children: [
                  buildSwitchListTile(
                    title: 'Show reports',
                    value: showReport,
                    onChanged: (newValue) {
                      setState(() {
                        showReport = newValue;
                      });
                    },
                  ),
                  buildSwitchListTile(
                    title: 'Show reported',
                    value: showReported,
                    onChanged: (newValue) {
                      setState(() {
                        showReported = newValue;
                      });
                    },
                  ),
                  buildSwitchListTile(
                    title: 'Show surveys',
                    value: showSurveys,
                    onChanged: (newValue) {
                      setState(() {
                        showSurveys = newValue;
                      });
                    },
                  ),
                  buildSwitchListTile(
                    title: 'Show unread',
                    value: showUnread,
                    onChanged: (newValue) {
                      setState(() {
                        showUnread = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loading = true;
                      });
                      updateDashboard(
                        showReport,
                        showReported,
                        showSurveys,
                        showUnread,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryRed,
                    ),
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Update',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              )),
    );
  }

  Widget buildSwitchListTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontSize: 28)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: primaryRed,
      ),
    );
  }
}
