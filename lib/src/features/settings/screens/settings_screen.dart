import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Obx(() => ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF075E54),
              child: Text(
                (auth.displayName.value.isNotEmpty ? auth.displayName.value : '?')[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            title: Text(
              auth.displayName.value.isNotEmpty ? auth.displayName.value : 'Set your name',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(auth.status.value),
            trailing: const Icon(Icons.qr_code_scanner, color: Color(0xFF075E54)),
          )),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _buildItem(Icons.key, 'Account', 'Privacy, security, change number'),
          _buildItem(Icons.chat_bubble_outline, 'Chats', 'Theme, wallpapers, chat history'),
          _buildItem(Icons.notifications_outlined, 'Notifications', 'Message and group notifications'),
          _buildItem(Icons.storage_outlined, 'Storage and data', 'Network usage, auto-download'),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _buildItem(Icons.info_outline, 'About and help', ''),
          Obx(() => ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout, color: Colors.red),
            ),
            title: const Text('Log out', style: TextStyle(color: Colors.red)),
            onTap: () async {
              await auth.signOut();
              Get.offAllNamed('/welcome');
            },
          )),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF075E54).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF075E54)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
