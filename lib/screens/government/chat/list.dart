import 'package:flutter/material.dart';
import 'package:ihuriro/screens/government/chat/chat_room.dart';
import 'package:ihuriro/screens/government/users/list.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';

class ListCharts extends StatefulWidget {
  const ListCharts({super.key});

  @override
  State<ListCharts> createState() => _ListChartsState();
}

class _ListChartsState extends State<ListCharts> {
  final List<Map<String, String>> messages = [
    {'name': 'Alice', 'message': 'Hello! How are you?'},
    {'name': 'Bob', 'message': 'Are you coming to the party?'},
    {'name': 'Charlie', 'message': 'Don\'t forget the meeting tomorrow.'},
    {'name': 'David', 'message': 'Check out this cool link!'},
    {'name': 'Eve', 'message': 'Happy Birthday!'},
  ];

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
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return Card(
            elevation: 2.0,
            margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 0.0),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: primaryRed,
                child: Text(
                  messages[index]['name']![0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                messages[index]['name']!,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: primaryRed),
              ),
              subtitle: Text(messages[index]['message']!),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoomScreen(
                      name: messages[index]['name']!,
                      message: messages[index]['message']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
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
