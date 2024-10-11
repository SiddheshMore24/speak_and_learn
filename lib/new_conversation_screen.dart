import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewConversationScreen extends StatefulWidget {
  @override
  _NewConversationScreenState createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> with SingleTickerProviderStateMixin {
  late stt.SpeechToText _speech;
  bool isListening = false;
  String _text = "";
  final _controller = TextEditingController();
  late AnimationController _animationController;
  List<Map<String, String>> responses = [];
  bool isLoading = true;

  int c = 0;
  int _wrongAttempts = 0;
  List<Map<String, String>> _currentChat = [];
  Timer? _timer;

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('https://my-json-server.typicode.com/tryninjastudy/dummyapi/db'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> restaurantData = data['restaurant'];

        setState(() {
          responses = List<Map<String, String>>.from(
              restaurantData.map((item) => Map<String, String>.from(item))
          );
          isLoading = false;
          // Initialize first message only after data is loaded
          if (responses.isNotEmpty) {
            _currentChat.add({"bot": responses[0]["bot"]!});
          }
        });
      } else {
        throw Exception("Failed to load data from API");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load conversation data. Please try again later.'))
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _text = "";
        isListening = true;
      });
      _animationController.repeat(reverse: true);
      _speech.listen(
        onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
          });
        },
      );

      _timer = Timer(Duration(seconds: 6), () {
        _stopListening();
      });
    }
  }

  void _stopListening() {
    _animationController.stop();
    setState(() {
      isListening = false;
    });
    _speech.stop();
    _timer?.cancel();

    if (_text.isNotEmpty) {
      _sendMessage(_text);
      _text = "";
    }
  }

  void _sendMessage(String message) {
    if (responses.isEmpty) return;

    setState(() {
      String expectedResponse = responses[c]["human"]!.toLowerCase();

      _currentChat.add({"human": message});

      if (message.trim().toLowerCase() == expectedResponse) {
        c++;
        _wrongAttempts = 0;
        if (c < responses.length) {
          _currentChat.add({"bot": responses[c]["bot"]!});
        } else {
          _showCompletionDialog();
        }
      } else {
        if (_wrongAttempts == 0) {
          _currentChat.add({
            "bot": "Sorry, that's not correct. The correct response is: ${responses[c]["human"]!}. Please try again."
          });
          _wrongAttempts++;
        } else {
          _currentChat.add({"bot": "You need more practice. Moving to the next question."});
          c++;
          _wrongAttempts = 0;

          if (c < responses.length) {
            _currentChat.add({"bot": responses[c]["bot"]!});
          } else {
            _showCompletionDialog();
          }
        }
      }
      _controller.clear();
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Congratulations! 🎉'),
        content: Text('You have completed the conversation practice!'),
        actions: [
          TextButton(
            child: Text('Return to Home'),
            onPressed: _endConversation,
          ),
        ],
      ),
    );
  }

  Future<void> _saveChatHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedChats = prefs.getStringList('savedChats') ?? [];
    String chatHistory = json.encode(_currentChat);
    savedChats.add(chatHistory);
    await prefs.setStringList('savedChats', savedChats);
  }

  void _endConversation() async {
    await _saveChatHistory();

    Navigator.pop(context);
    Navigator.pop(context);
    // Navigator.pushReplacementNamed(context, '/home');
  }

  Widget _buildMessage(Map<String, String> message) {
    final isBot = message.containsKey('bot');
    final text = isBot ? message['bot']! : message['human']!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot)
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.android, color: Colors.blue[900]),
              radius: 16,
            ),
          SizedBox(width: isBot ? 8 : 0),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration: BoxDecoration(
                color: isBot ? Colors.blue[50] : Colors.green[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isBot ? 0 : 20),
                  topRight: Radius.circular(isBot ? 20 : 0),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: !isBot ? 8 : 0),
          if (!isBot)
            CircleAvatar(
              backgroundColor: Colors.green[100],
              child: Icon(Icons.person, color: Colors.green[900]),
              radius: 16,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          "English Conversation Practice",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _endConversation,
            tooltip: "End Conversation",
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              color: Colors.blue[50],
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue[900]),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Press the microphone button to record your voice. Recording stops after 5 seconds.",
                      style: TextStyle(color: Colors.blue[900], fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                itemCount: _currentChat.length,
                itemBuilder: (context, index) {
                  return _buildMessage(_currentChat[index]);
                },
              ),
            ),
            if (isListening)
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    color: Colors.blue[50],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.0 + (_animationController.value * 0.2),
                          child: const Icon(Icons.mic, color: Colors.red, size: 48),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _text.isEmpty ? "Listening..." : _text,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      isListening ? Icons.mic_off : Icons.mic,
                      size: 36,
                      color: isListening ? Colors.red : Colors.blue[900],
                    ),
                    onPressed: isListening ? _stopListening : _startListening,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: _sendMessage,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send, color: Colors.blue[900]),
                    onPressed: () => _sendMessage(_controller.text),
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