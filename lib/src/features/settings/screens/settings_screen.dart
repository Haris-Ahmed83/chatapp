import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/features/settings/screens/account_screen.dart';
import 'package:chato/src/features/settings/screens/chats_settings_screen.dart';
import 'package:chato/src/features/settings/screens/notifications_screen.dart';
import 'package:chato/src/features/settings/screens/storage_screen.dart';
import 'package:chato/src/features/settings/screens/about_screen.dart';

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
          Obx(() {
            final name = auth.displayName.value.isNotEmpty ? auth.displayName.value : 'Set your name';
            final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
            return ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF075E54),
                child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 24)),
              ),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(auth.status.value),
              trailing: const Icon(Icons.qr_code_scanner, color: Color(0xFF075E54)),
              onTap: () => Get.to(() => AccountScreen()),
            );
          }),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _buildItem(
            Icons.key, 'Account', 'Privacy, security, change number',
            () => Get.to(() => AccountScreen()),
          ),
          _buildItem(
            Icons.chat_bubble_outline, 'Chats', 'Theme, wallpapers, chat history',
            () => Get.to(() => const ChatsSettingsScreen()),
          ),
          _buildItem(
            Icons.notifications_outlined, 'Notifications', 'Message and group notifications',
            () => Get.to(() => const NotificationsScreen()),
          ),
          _buildItem(
            Icons.storage_outlined, 'Storage and data', 'Network usage, auto-download',
            () => Get.to(() => const StorageScreen()),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),
          _buildItem(
            Icons.info_outline, 'About and help', '',
            () => Get.to(() => const AboutScreen()),
          ),
          Obx(() {
            return ListTile(
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
                Get.offAllNamed(AppRoutes.welcome);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildItem(IconData icon, String title, String subtitle, VoidCallback? onTap) {
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
      onTap: onTap ?? () {},
    );
  }
}
