import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/model/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  final String nickName;
  const ChatPage({super.key, required this.nickName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  String userId = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Load user ID from SharedPreferences
  void _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat - ${widget.nickName}'),
        ),
        body: Column(
          children: [
            // Display chat messages in a ListView
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: db.collection('chat').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final messages = snapshot.data!.docs;
                  List<Widget> messageWidgets = [];
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageSender = message['nickname'];
                    final messageWidget = Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: Align(
                        alignment: messageSender == widget.nickName
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color: messageSender == widget.nickName
                                ? Colors.blue
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            '$messageSender: $messageText',
                            style: TextStyle(
                              color: messageSender == widget.nickName
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    reverse:
                        true, // Show the most recent messages at the bottom
                    children: messageWidgets,
                  );
                },
              ),
            ),

            // Input field and send button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Escreva sua mensagem',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  SizedBox(
                    width: 48.0, // Fixed width for the button
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_messageController.text.isNotEmpty) {
                          var model = ChatModel(
                            text: _messageController.text,
                            userId: userId,
                            nickname: widget.nickName,
                          );
                          await db.collection('chat').add(model.toJson());
                          _messageController.clear();
                        }
                      },
                      child: const Align(
                        alignment: Alignment.center,
                        child: Icon(Icons.send),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
