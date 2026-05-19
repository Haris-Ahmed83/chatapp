import 'package:flutter/material.dart';

class WaColors {
  WaColors._();

  static const primary = Color(0xFF075E54);
  static const accent = Color(0xFF25D366);
  static const chatBg = Color(0xFFECE5DD);
  static const sentBubble = Color(0xFFDCF8C5);
  static const receivedBubble = Colors.white;
  static const appBar = Color(0xFF075E54);
  static const appBarText = Colors.white;
  static const tabSelected = Color(0xFF075E54);
  static const tabUnselected = Color(0xFFA0A0A0);
  static const statusOnline = Color(0xFF25D366);
  static const unreadBadge = Color(0xFF25D366);
  static const searchIcon = Color(0xFF8E8E93);
  static const divider = Color(0xFFE0E0E0);
  static const subtitle = Color(0xFF667781);
  static const timestamp = Color(0xFF8E8E93);
  static const verified = Color(0xFF34B7F1);
  static const error = Color(0xFFE53935);
}

ThemeData buildWaLightTheme() {
  const primary = WaColors.primary;
  const onPrimary = Colors.white;

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    onPrimary: onPrimary,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: WaColors.chatBg,

    appBarTheme: const AppBarTheme(
      backgroundColor: WaColors.appBar,
      foregroundColor: WaColors.appBarText,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: WaColors.accent,
      foregroundColor: Colors.white,
      elevation: 6,
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFFB0B0B0),
      indicatorColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
    ),

    dividerTheme: const DividerThemeData(
      color: WaColors.divider,
      thickness: 0.5,
      space: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: WaColors.primary, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      hintStyle: TextStyle(color: Colors.grey[400]),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: WaColors.primary,
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: WaColors.primary,
      unselectedItemColor: WaColors.tabUnselected,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(fontSize: 12),
    ),

    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
