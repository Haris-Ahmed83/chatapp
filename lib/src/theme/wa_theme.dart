import 'package:flutter/material.dart';

const waPrimary = Color(0xFF075E54);
const waPrimaryDark = Color(0xFF054D44);
const waAccent = Color(0xFF25D366);
const waSecondary = Color(0xFF128C7E);
const waChatBubbleSent = Color(0xFFDCF8C6);
const waChatBubbleReceived = Colors.white;
const waChatBg = Color(0xFFECE5DD);
const waBgDark = Color(0xFF0B141A);

final waTheme = ThemeData(
  primaryColor: waPrimary,
  scaffoldBackgroundColor: waChatBg,
  colorScheme: ColorScheme.fromSeed(
    seedColor: waPrimary,
    primary: waPrimary,
    secondary: waAccent,
    surface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: waPrimary,
    foregroundColor: Colors.white,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: waAccent,
    foregroundColor: Colors.white,
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
    unselectedLabelColor: Colors.white70,
    indicatorColor: Colors.white,
    indicatorSize: TabBarIndicatorSize.tab,
  ),
  dividerTheme: const DividerThemeData(
    color: Color(0xFFF0F0F0),
    thickness: 0.5,
  ),
);
