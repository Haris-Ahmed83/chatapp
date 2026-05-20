import 'package:flutter/material.dart';
import 'package:chato/src/config/app_config.dart';
import 'package:chato/src/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AppConfig.init();
    runApp(const ChatoApp());
  } catch (e) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF075E54),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text('Failed to initialize: $e', style: const TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center),
          ),
        ),
      ),
    ));
  }
}
