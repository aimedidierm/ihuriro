import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ihuriro/constants/api_constants.dart';
import 'package:ihuriro/models/api_response.dart';
import 'package:ihuriro/screens/theme/colors.dart';
import 'package:ihuriro/screens/widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'package:ihuriro/services/auth.dart';
import 'package:ihuriro/services/message.dart';

class ChatRoomScreen extends StatefulWidget {
  final int receiver;
  final String name;

  ChatRoomScreen({
    required this.receiver,
    required this.name,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  bool _loading = true;
  final formkey = GlobalKey<FormState>();
  final TextEditingController message = TextEditingController();

  List<Map<String, dynamic>> _allChats = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> fetchData() async {
    String token = await getToken();
    final response = await http
        .get(Uri.parse('$chatRoomURL/${widget.receiver}'), headers: {
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
      // Sort chats by created_at
      _allChats.sort((a, b) => DateTime.parse(a['created_at'])
          .compareTo(DateTime.parse(b['created_at'])));

      // Scroll to the bottom when the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  }

  void sendMessage() async {
    ApiResponse response = await sendContent(widget.receiver, message.text);
    if (response.error == null) {
      message.clear();
      fetchData();
    } else {
      // Handle error
      // print(response.error);
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
                      Text(
                        widget.name,
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
          _loading
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryRed,
                  ),
                )
              : Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.teal[50]!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _allChats.length,
                    itemBuilder: (context, index) {
                      var chat = _allChats[index];
                      bool isMe = chat['receiver_id'] == widget.receiver;
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
                            chat['content'],
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
              child: Form(
                key: formkey,
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: message,
                        validator: (val) =>
                            val!.isEmpty ? "Message can't be empty" : null,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: primaryRed),
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          sendMessage();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
