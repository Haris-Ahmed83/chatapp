import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatsSettingsScreen extends StatefulWidget {
  const ChatsSettingsScreen({super.key});

  @override
  State<ChatsSettingsScreen> createState() => _ChatsSettingsScreenState();
}

class _ChatsSettingsScreenState extends State<ChatsSettingsScreen> {
  bool _darkMode = false;
  bool _enterIsSend = true;

  @override
  Widget build(BuildContext context) {
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
            title: const Text('Dark mode'),
            subtitle: const Text('Use dark theme'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
            activeColor: const Color(0xFF075E54),
          ),
          SwitchListTile(
            title: const Text('Enter is send'),
            subtitle: const Text('Press Enter to send messages'),
            value: _enterIsSend,
            onChanged: (v) => setState(() => _enterIsSend = v),
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
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            ),
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
            onTap: () => Get.snackbar('Chat history', 'Export or clear all chat history',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            ),
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
            onTap: () => Get.snackbar('Backup', 'Configure Google Drive backup',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 2),
            ),
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
