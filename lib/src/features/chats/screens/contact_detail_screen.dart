import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/config/app_config.dart';
import 'package:chato/src/routing/app_routes.dart';

class ContactDetailScreen extends StatefulWidget {
  const ContactDetailScreen({super.key});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  final args = Get.arguments as Map<String, dynamic>?;
  String _phone = '';
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final otherUid = args?['other_uid'] as String? ?? '';
    if (otherUid.isEmpty) return;
    try {
      final doc = await AppConfig.firestore.collection('profiles').doc(otherUid).get();
      final data = doc.data();
      if (data != null) {
        setState(() {
          _phone = data['phone'] as String? ?? '';
          _status = data['status'] as String? ?? '';
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final name = args?['name'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Contact info'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 32),
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: const Color(0xFF075E54),
              child: Text(
                (name as String)[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 36),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(child: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
          if (_status.isNotEmpty)
            Center(child: Text(_status, style: TextStyle(fontSize: 14, color: Colors.grey[600]))),
          const SizedBox(height: 24),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.phone, color: Color(0xFF075E54)),
            title: const Text('Voice call'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => Get.toNamed(AppRoutes.call, arguments: {'name': name}),
          ),
          ListTile(
            leading: const Icon(Icons.videocam, color: Color(0xFF075E54)),
            title: const Text('Video call'),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => Get.snackbar('Video call', 'Coming soon', snackPosition: SnackPosition.BOTTOM),
          ),
          if (_phone.isNotEmpty)
            ListTile(
              leading: const Icon(Icons.phone_android, color: Color(0xFF075E54)),
              title: Text(_phone),
              onTap: () {},
            ),
        ],
      ),
    );
  }
}
