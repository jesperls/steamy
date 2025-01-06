import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String matchedUserName; // Name
  final int matchedUserId; // ID

  const ChatScreen({
    super.key,
    required this.matchedUserName,
    required this.matchedUserId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ApiService apiService = ApiService();
  int _currentUserId = 0;

  @override
  void initState() {
    super.initState();
    apiService.ensureLoggedIn(context);
    _loadCurrentUserId();
    _fetchMessages();
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = int.tryParse(prefs.getString('userId') ?? '') ?? 0;
  }

  Future<void> _fetchMessages() async {
    try {
      final fetchedMessages = await apiService.fetchChatMessages(widget.matchedUserId);
      setState(() {
        _messages.clear();
        for (var msg in fetchedMessages) {
          final senderName = (msg['sender_id'] == _currentUserId)
            ? "You"
            : widget.matchedUserName;
          _messages.add({
            "sender": senderName,
            "text": msg['message_text'],
          });
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages: $error')),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  // Send message function to POST to server
  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final messageText = _messageController.text.trim();

    try {
      await apiService.sendChatMessage(widget.matchedUserId, messageText);
      setState(() {
        _messages.add({"sender": "You", "text": messageText});
      });
      _messageController.clear();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat with ${widget.matchedUserName}"),
      ),
      body: Column(
        children: [
          // Messages display section
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[_messages.length - 1 - index];
                return ListTile(
                  title: Align(
                    alignment: message['sender'] == "You"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: message['sender'] == "You"
                            ? Colors.blue[100]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        message['text']!,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          // Input field for user to send message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
