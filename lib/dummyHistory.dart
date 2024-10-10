import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final List<Map<String, String>> _chatMessages = [
    {'sender': 'bot', 'message': 'Hello! How can I assist you today?'},
    {'sender': 'human', 'message': 'Hi! I want to know more about Flutter.'},
    {'sender': 'bot', 'message': 'Flutter is an open-source UI software development kit by Google.'},
    {'sender': 'human', 'message': 'That sounds interesting! Can you tell me more?'},
    {'sender': 'bot', 'message': 'Sure! It’s used to develop cross-platform applications from a single codebase.'},
  ];

  Widget _buildChatBubble(String message, bool isBot) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        constraints: BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isBot ? Colors.grey[200] : Colors.blue[200],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: isBot ? Radius.circular(0) : Radius.circular(15),
            bottomRight: isBot ? Radius.circular(15) : Radius.circular(0),
          ),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: isBot ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dummy chat messages'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                var message = _chatMessages[index];
                bool isBot = message['sender'] == 'bot';
                return _buildChatBubble(message['message']!, isBot);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  color: Colors.blue,
                  onPressed: () {

                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
