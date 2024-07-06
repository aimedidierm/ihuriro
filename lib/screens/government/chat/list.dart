import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/screens/government/chat/chat_room.dart';
import 'package:ihuriro/screens/government/users/list.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:ihuriro/services/auth.dart';

class ListCharts extends StatefulWidget {
  const ListCharts({super.key});

  @override
  State<ListCharts> createState() => _ListChartsState();
}

class _ListChartsState extends State<ListCharts> {
  bool _loading = true;

  List<Map<String, dynamic>> _allChats = [];

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http.get(Uri.parse(listingChatURL), headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(response.body);
      final List<dynamic> decodedChats = decodedResponse['chats'];
      final List<Map<String, dynamic>> chats =
          List<Map<String, dynamic>>.from(decodedChats);
      setState(() {
        _allChats = chats;
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
                      const SizedBox(width: 10),
                      const SizedBox(width: 10),
                      const Text(
                        "Chats",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
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
            : ListView.builder(
                itemCount: _allChats.length,
                itemBuilder: (context, index) {
                  var name = 'Mugisha';
                  int id = 0;
                  var chat = _allChats[index];
                  var messageUser = chat['message_user'];
                  if (chat['user'] != null) {
                    name = chat['user']['name'];
                    id = chat['user']['id'];
                  }
                  if (chat['receiver'] != null) {
                    name = chat['receiver']['name'];
                    id = chat['receiver']['id'];
                  }
                  return Card(
                    elevation: 2.0,
                    color:
                        (messageUser != null && messageUser['is_read'] == false)
                            ? primaryRed.withOpacity(0.3)
                            : null,
                    margin: const EdgeInsets.symmetric(
                        vertical: 3, horizontal: 0.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: primaryRed,
                        child: Text(
                          name[0],
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: primaryRed),
                      ),
                      subtitle: Text(_allChats[index]['content']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoomScreen(
                              receiver: id,
                              name: name,
                              message: chat['content']!,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: Visibility(
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LawUsersList(),
              ),
            );
          },
          child: Icon(
            Icons.group,
            color: primaryRed,
          ),
        ),
      ),
    );
  }
}
