import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/settings/presentation/controllers/settings_controller.dart';
import 'package:chato/src/features/auth/presentation/controllers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(() {
      return ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 28, color: Colors.white),
            ),
            title: Text(Get.find<AuthController>().displayName.value,
                style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text('Tap to edit profile'),
            trailing: const Icon(Icons.qr_code),
            onTap: () {},
          ),
          const Divider(indent: 72),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Settings', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)),
          ),
          _SettingsItem(icon: Icons.notifications_outlined, title: 'Notifications', onTap: () {}),
          _SettingsItem(icon: Icons.lock_outline, title: 'Privacy', onTap: () {}),
          _SettingsItem(icon: Icons.storage_outlined, title: 'Data and storage', onTap: () {}),
          _SettingsItem(icon: Icons.language, title: 'App language', onTap: () {}),
          const Divider(),
          _SettingsItem(icon: Icons.info_outline, title: 'About & help', onTap: () {}),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark mode'),
            value: settings.isDarkMode.value,
            onChanged: (value) => settings.toggleDarkMode(),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log out', style: TextStyle(color: Colors.red)),
            onTap: () => Get.find<AuthController>().signOut(),
          ),
        ],
      );
    });
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _SettingsItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF075E54)),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}
