import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('About and help'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          Center(
            child: Column(
              children: [
                const Icon(Icons.chat_bubble_outline, size: 64, color: Color(0xFF075E54)),
                const SizedBox(height: 8),
                const Text('WhatsApp', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('Version 1.0.0', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF075E54)),
            title: const Text('About'),
            subtitle: Text('App information', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: Color(0xFF075E54)),
            title: const Text('Help'),
            subtitle: Text('FAQs, contact us', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: Color(0xFF075E54)),
            title: const Text('Terms & Privacy Policy'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
