import 'package:flutter/material.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';

class ChatRoom extends StatelessWidget {
  final String name;
  final String message;

  ChatRoom({required this.name, required this.message});

  final List<Map<String, String>> chatMessages = [
    {'sender': 'Alice', 'text': 'Hello! How are you?'},
    {'sender': 'Me', 'text': 'I am good, thanks! How about you?'},
    {'sender': 'Alice', 'text': 'I am doing well, just busy with work.'},
    {'sender': 'Me', 'text': 'Same here. Have you finished the project?'},
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
                      Text(
                        name,
                        style: const TextStyle(
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.teal[50]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: chatMessages.length,
              itemBuilder: (context, index) {
                bool isMe = chatMessages[index]['sender'] == 'Me';
                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: isMe ? primaryRed : primaryPink,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      chatMessages[index]['text']!,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              color: Colors.white,
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: primaryRed),
                    onPressed: () {},
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
