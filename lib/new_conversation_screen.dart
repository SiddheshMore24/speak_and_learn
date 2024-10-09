import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

class NewConversationScreen extends StatefulWidget {
  final Function on_ending_conversation;

  NewConversationScreen({required this.on_ending_conversation});

  @override
  _NewConversationScreenState createState() => _NewConversationScreenState();
}

class _NewConversationScreenState extends State<NewConversationScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  final _controller = TextEditingController();
  final List<Map<String, String>> _predefinedResponses = [
    {"bot": "Hello", "human": "Good afternoon"},
    {"bot": "Welcome to the restaurant", "human": "Thank you"},
    {"bot": "What would you like?", "human": "I would like a tea"},
    {"bot": "Would you like some food?", "human": "A fish please"},
    {"bot": "Anything else?", "human": "Yes, with grilled vegetables"},
    {"bot": "Would you like some water?", "human": "Yes, please"}
  ];
  int _step = 0;
  int _wrongAttempts = 0;
  List<Map<String, String>> _currentChat = [];
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _currentChat.add({"bot": _predefinedResponses[0]["bot"]!});
  }

  void _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() {
        _isListening = true;
        _text = ""; // Reset the text
      });
      _speech.listen(onResult: (val) {
        setState(() {
          _text = val.recognizedWords;
        });
      });

      _timer = Timer(Duration(seconds: 5), () {
        _stopListening();
      });
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
    });
    _speech.stop();
    _timer?.cancel();

    if (_text.isNotEmpty) {
      _sendMessage(_text);
    }
  }

  void _sendMessage(String message) {
    setState(() {
      String expectedResponse = _predefinedResponses[_step]["human"]!.toLowerCase();

      _currentChat.add({"human": message});

      if (message.trim().toLowerCase() == expectedResponse) {
        _step++;
        _wrongAttempts = 0;

        if (_step < _predefinedResponses.length) {
          _currentChat.add({"bot": _predefinedResponses[_step]["bot"]!});
        } else {
          _currentChat.add({"bot": "Thank you for the conversation!"});
        }
      } else {
        if (_wrongAttempts == 0) {
          _currentChat.add({"bot": "Sorry, I didn't understand."});
          _wrongAttempts++;
        } else {
          _currentChat.add({"bot": "Correct response is: ${_predefinedResponses[_step]["human"]!}"});
          _wrongAttempts++;

          if (_wrongAttempts >= 2) {
            _step++;
            _wrongAttempts = 0;

            if (_step < _predefinedResponses.length) {
              _currentChat.add({"bot": _predefinedResponses[_step]["bot"]!});
            } else {
              _currentChat.add({"bot": "Thank you for the conversation!"});
            }
          }
        }
      }
      _controller.clear();
    });
  }

  void _endConversation() {
    widget.on_ending_conversation();
    Navigator.pop(context);
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
          if (_isListening)
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic, color: Colors.red),
                  SizedBox(width: 8),
                  Text(
                    "Listening...",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
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
                  onTapDown: (_) => _startListening(),
                  onTapUp: (_) => _stopListening(),
                  onTapCancel: () => _stopListening(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_none,
                      color: _isListening ? Colors.red : Colors.blue,
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
