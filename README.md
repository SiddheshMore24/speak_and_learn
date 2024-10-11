# Speak & Learn

A Flutter application that helps users practice English conversations through speech recognition. Users can engage in predefined conversation scenarios with a bot, speaking their responses or typing them.

## Features

- Voice recognition for speaking practice
- Predefined conversation scenarios
- Real-time feedback on responses
- Simple and intuitive interface
- Text input option available

## Download

[Download APK v1.0.0](https://drive.google.com/drive/folders/1y-1g2XQObqqJdT-CgBYS04ajXD-nAb1q?usp=sharing)

## Installation Guide

### For Users
1. Download the APK from the link above
2. Enable "Install from Unknown Sources" in your Android settings
3. Install the APK
4. Grant microphone permissions when prompted

### For Developers

1. Make sure you have Flutter installed on your machine. If not, follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install)

2. Clone the repository:
```
git clone https://github.com/SiddheshMore24/speak_and_learn.git
```

3. Navigate to project directory and get dependencies:
```
cd speak_and_learn
flutter pub get
```

4. Add the following code to your `pubspec.yaml`:
```
dependencies:
  flutter:
    sdk: flutter
  speech_to_text: ^7.0.0
  http: ^1.2.2
```

5. Add these permissions to `android/app/src/main/AndroidManifest.xml`:
```
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.INTERNET"/>
```

6. Add this to `ios/Runner/Info.plist` for iOS development:
```
<key>NSMicrophoneUsageDescription</key>
<string>This application needs to access your microphone for speech recognition</string>
<key>NSSpeechRecognitionUsageDescription</key>
<string>This application needs the speech recognition permission for converting speech to text</string>
```

7. Create your conversation data in this format:
```

{
    "restaurant": [
        {
            "bot": "Hello",
            "human": "Good afternoon"
        },
        {
            "bot": "Welcome to the restaurant",
            "human": "Thank you"
        },
        {
            "bot": "What would you like?",
            "human": "I would like a tea"
        },
        {
            "bot": "Would you like some food?",
            "human": "A fish please"
        },
        {
            "bot": "Anything else?",
            "human": "Yes, with grilled vegetables"
        },
        {
            "bot": "Would you like some water?",
            "human": "Yes, please"
        }
    ]
}
```

## How to Use

1. Open the app
2. Press the microphone button to start speaking
3. Speak your response (recording stops automatically after 5 seconds)
4. Get feedback on your response
5. Continue the conversation to practice

## System Requirements

- Android 5.0 or higher
- Microphone access
- Internet connection

## Contact

For any queries, please reach out to: your.email@example.com

---
Built with Flutter 💙
