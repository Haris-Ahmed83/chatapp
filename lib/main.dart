import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/config/app_config.dart';
import 'package:chato/src/app.dart';
import 'package:chato/src/routing/app_bindings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AppConfig.init();
  } catch (_) {}
  runApp(const ChatoApp());
}
