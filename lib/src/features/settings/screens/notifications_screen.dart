import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool _messageNotifications = true;
  bool _groupNotifications = true;
  bool _showPreview = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          _section('Message notifications'),
          SwitchListTile(
            title: const Text('Show notifications'),
            value: _messageNotifications,
            onChanged: (v) => setState(() => _messageNotifications = v),
            activeColor: const Color(0xFF075E54),
          ),
          SwitchListTile(
            title: const Text('Show preview'),
            subtitle: const Text('Show message text in notification'),
            value: _showPreview,
            onChanged: (v) => setState(() => _showPreview = v),
            activeColor: const Color(0xFF075E54),
          ),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF075E54).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.music_note, color: Color(0xFF075E54), size: 20),
            ),
            title: const Text('Notification tone'),
            subtitle: Text('Default', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          _section('Group notifications'),
          SwitchListTile(
            title: const Text('Show group notifications'),
            value: _groupNotifications,
            onChanged: (v) => setState(() => _groupNotifications = v),
            activeColor: const Color(0xFF075E54),
          ),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF075E54).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.music_note, color: Color(0xFF075E54), size: 20),
            ),
            title: const Text('Group notification tone'),
            subtitle: Text('Default', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
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
