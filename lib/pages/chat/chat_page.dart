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
          backgroundColor: Colors.teal, // Changed for a more professional look
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
                    final isCurrentUser = messageSender == widget.nickName;
                    final messageWidget = Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 12.0),
                      child: Align(
                        alignment: isCurrentUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                isCurrentUser ? Colors.teal : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messageSender,
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                messageText,
                                style: TextStyle(
                                  color: isCurrentUser
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    reverse:
                        true, // Show the most recent messages at the bottom
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        hintText: 'Digite sua mensagem...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  SizedBox(
                    width: 48.0, // Set a fixed width for the button
                    height:
                        48.0, // Set a fixed height to maintain a square shape
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Updated parameter
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(Icons.send, size: 24.0),
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
