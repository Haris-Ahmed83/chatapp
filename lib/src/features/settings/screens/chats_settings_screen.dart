import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsSettingsScreen extends StatefulWidget {
  const ChatsSettingsScreen({super.key});

  @override
  State<ChatsSettingsScreen> createState() => _ChatsSettingsScreenState();
}

class _ChatsSettingsScreenState extends State<ChatsSettingsScreen> {
  bool _enterIsSend = true;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _enterIsSend = prefs.getBool('chats_enter_send') ?? true;
      _loaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Chats'),
      ),
      body: ListView(
        children: [
          _section('Display'),
          SwitchListTile(
            title: const Text('Enter is send'),
            subtitle: const Text('Press Enter to send messages'),
            value: _enterIsSend,
            onChanged: (v) async {
              setState(() => _enterIsSend = v);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('chats_enter_send', v);
            },
            activeColor: const Color(0xFF075E54),
          ),
          _section('Wallpaper'),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF075E54).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wallpaper, color: Color(0xFF075E54), size: 20),
            ),
            title: const Text('Set wallpaper'),
            subtitle: Text('Change chat background', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: Container(width: 36, height: 36, decoration: BoxDecoration(
              color: const Color(0xFFECE5DD),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            )),
            onTap: () => Get.snackbar('Wallpaper', 'Choose from gallery',
              snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2)),
          ),
          _section('History'),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF075E54).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history, color: Color(0xFF075E54), size: 20),
            ),
            title: const Text('Chat history'),
            subtitle: Text('Export or clear chats', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => Get.snackbar('Chat history', 'Export chat or clear all chats',
              snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2)),
          ),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF075E54).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.backup, color: Color(0xFF075E54), size: 20),
            ),
            title: const Text('Backup'),
            subtitle: Text('Google Drive backup', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => Get.snackbar('Backup', 'Backup chats to Google Drive',
              snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 2)),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: const Color(0xFF075E54),
      )),
    );
  }
}
