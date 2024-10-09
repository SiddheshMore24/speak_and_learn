import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

class NewConversationScreen extends StatefulWidget {
  @override
  _NewConversationScreenState createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  late stt.SpeechToText _speech;
  bool isListening = false;
  String _text = "";
  final _controller = TextEditingController();
  final List<Map<String, String>> responses = [
    {"bot": "Hello", "human": "Good afternoon"},
    {"bot": "Welcome to the restaurant", "human": "Thank you"},
    {"bot": "What would you like?", "human": "I would like a tea"},
    {"bot": "Would you like some food?", "human": "A fish please"},
    {"bot": "Anything else?", "human": "Yes, with grilled vegetables"},
    {"bot": "Would you like some water?", "human": "Yes, please"}
  ];
  int c = 0;
  int _wrongAttempts = 0;
  List<Map<String, String>> _currentChat = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _currentChat.add({"bot": responses[0]["bot"]!});
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        isListening = true;
        _text = ""; // Reset the text
      });
      _speech.listen(onResult: (val) {
        setState(() {
          _text = val.recognizedWords;
        });
      });

      _timer = Timer(Duration(seconds: ), () {
        _stopListening();
      });
    }
  }

  void _stopListening() {
    setState(() {
      isListening = false;
    });
    _speech.stop();
    _timer?.cancel();
    if (_text.isNotEmpty) {
      _sendMessage(_text);
    }
  }
  void _sendMessage(String message) {
    setState(() {
      String expectedResponse = responses[c]["human"]!.toLowerCase();


      _currentChat.add({"human": message});

      if (message.trim().toLowerCase() == expectedResponse) {
        // Correct response
        c++;
        _wrongAttempts = 0;
        if (c < responses.length) {
          _currentChat.add({"bot": responses[c]["bot"]!});
        } else {
          _currentChat.add({"bot": "Thank you for the conversation!"});
        }
      } else {
        // Incorrect response
        if (_wrongAttempts == 0) {
          // First incorrect attempt
          _currentChat.add({"bot": "Sorry, that's not correct. The correct response is: ${responses[c]["human"]!}. Please try again."});
          _wrongAttempts++;
        } else {
          _currentChat.add({"bot": "You need more practice. Moving to the next question."});
          c++;
          _wrongAttempts = 0;

          if (c < responses.length) {
            _currentChat.add({"bot": responses[c]["bot"]!});
          } else {
            _currentChat.add({"bot": "Thank you for the conversation!"});
          }
        }
      }
      _controller.clear();
    });
  }

  void _endConversation() {
    Navigator.pop(context); // Pop the current screen
    Navigator.pushReplacementNamed(context, '/home'); // Replace with the home screen
  }

  Widget _buildMessage(Map<String, String> message) {
    final isBot = message.containsKey('bot');
    final text = isBot ? message['bot']! : message['human']!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
            decoration: BoxDecoration(
              color: isBot ? Colors.grey[200] : Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Conversation"),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _endConversation,
            tooltip: "End Conversation",
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Hold the mic button to record your voice. It will record for 5 seconds.",
              style: TextStyle(color: Colors.black54),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _currentChat.length,
              itemBuilder: (context, index) {
                return _buildMessage(_currentChat[index]);
              },
            ),
          ),
          if (isListening)
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic, color: Colors.red, size: 48),
                  SizedBox(height: 8),
                  Text(
                    "Please speak...",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Type your message",
                suffixIcon: GestureDetector(
                  onTapDown: (_) => _startListening(), // Start listening when pressed
                  onTapUp: (_) => _stopListening(), // Stop listening when released
                  onTapCancel: () => _stopListening(), // Stop listening if the gesture is canceled
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      isListening ? Icons.mic : Icons.mic_none,
                      color: isListening ? Colors.red : Colors.blue,
                      size: 30,
                    ),
                  ),
                ),
              ),
              onSubmitted: (value) {
                _sendMessage(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
