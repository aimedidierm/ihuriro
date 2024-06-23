import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/screens/government/users/create.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:ihuriro/services/auth.dart';

class LawUsersList extends StatefulWidget {
  const LawUsersList({super.key});

  @override
  State<LawUsersList> createState() => _LawUsersListState();
}

class _LawUsersListState extends State<LawUsersList> {
  bool _loading = true;

  List<Map<String, dynamic>> _allUsers = [];

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(governmentLawUsersdURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<dynamic> decodedUsers = decodedResponse['users'];
      final List<Map<String, dynamic>> users =
          List<Map<String, dynamic>>.from(decodedUsers);
      setState(() {
        _allUsers = users;
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
                        'Manage Law Users',
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      itemCount: _allUsers.length,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(index),
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          children: [
                            ListTile(
                              title: Row(
                                children: [
                                  const Text(
                                    "Name: ",
                                    textAlign: TextAlign.justify,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _allUsers[index]['name'],
                                    textAlign: TextAlign.justify,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () {},
                              subtitle: Row(
                                children: [
                                  const Text('Email: '),
                                  Text(
                                    _allUsers[index]['email'],
                                  ),
                                ],
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
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateLawUser(),
              ),
            );
          },
          child: Icon(
            Icons.group_add,
            color: primaryRed,
          ),
        ),
      ),
    );
  }
}
