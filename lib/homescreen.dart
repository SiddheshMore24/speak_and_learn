import 'package:flutter/material.dart';
import 'new_conversation_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _chatHistory = [
    {
      'id': 1,
      'title': 'Restaurant Conversation',
      'last_message': 'Would you like some water?',
      'date': '2024-10-09',
      'completion': 85,
      'total_messages': 12,
    },
    {
      'id': 2,
      'title': 'Shopping Dialog',
      'last_message': 'How much does this cost?',
      'date': '2024-10-08',
      'completion': 100,
      'total_messages': 8,
    },
    {
      'id': 3,
      'title': 'Airport Check-in',
      'last_message': 'Here is my passport',
      'date': '2024-10-07',
      'completion': 60,
      'total_messages': 15,
    },
    {
      'id': 4,
      'title': 'Hotel Booking',
      'last_message': 'I have a reservation',
      'date': '2024-10-06',
      'completion': 40,
      'total_messages': 10,
    },
    {
      'id': 5,
      'title': 'Doctor Appointment',
      'last_message': 'I have a headache',
      'date': '2024-10-05',
      'completion': 90,
      'total_messages': 14,
    },
  ];

  // Function to start a new conversation
  void _startNewConversation() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewConversationScreen(),
      ),
    );

    // Add a new chat dynamically after returning from the new conversation screen
    setState(() {
      _chatHistory.add({
        'id': _chatHistory.length + 1,
        'title': 'New Chat ${_chatHistory.length + 1}',
        'last_message': 'New conversation started...',
        'date': DateTime.now().toString().substring(0, 10),
        'completion': 70, // Default completion
        'total_messages': 1,
      });
    });
  }

  // Building the conversation tile
  Widget _buildConversationTile(Map<String, dynamic> chat) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          // Handle chat tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      chat['title'],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${chat['completion']}%',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: chat['completion'] / 100,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  chat['completion'] == 100 ? Colors.green : Colors.blue,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.message_outlined, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      chat['last_message'],
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        chat['date'],
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey[600]),
                      SizedBox(width: 4),
                      Text(
                        '${chat['total_messages']} messages',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'English Practice',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Practice Stats',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900],
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '5',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    'Sessions',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '75%',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  Text(
                                    'Accuracy',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
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
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Conversations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all conversations
                  },
                  child: Text('View All'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                return _buildConversationTile(_chatHistory[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startNewConversation,
        label: Text('New Conversation'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
