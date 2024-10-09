import 'package:flutter/material.dart';
import 'package:speak_it/new_conversation_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy
  List<Map<String, dynamic>> _chatHistory = [
    {
      'id': 1,
      'last_message': 'Hello , this is Chat 1 ',
    },
    {
      'id': 2,
      'last_message': 'Hello , this is Chat 2',
    },
    {
      'id': 3,
      'last_message': 'Hello , this is Chat 3',
    },
    {
      'id': 4,
      'last_message': 'Hello , this is Chat 4',
    },
    {
      'id': 5,
      'last_message': 'Hello , this is Chat 5',
    },
  ];



  Widget _buildConversationTile(Map<String, dynamic> chat) {
    return ListTile(
      title: Text('Chat ${chat['id']}'),
      subtitle: Text(chat['last_message'] ?? 'No messages'),
      onTap: () {

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat History'),
      ),
      body: ListView.builder(
        itemCount: _chatHistory.length,
        itemBuilder: (context, index) {
          return _buildConversationTile(_chatHistory[index]);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=>NewConversationScreen()));
        },
        tooltip: 'Start New Conversation',
        child: Icon(Icons.add),
      ),
    );
  }
}
