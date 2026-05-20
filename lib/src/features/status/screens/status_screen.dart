import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF25D366),
            ),
            child: const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey,
              child: Icon(Icons.add, color: Colors.white),
            ),
          ),
          title: const Text('My status', style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text('Tap to add status update'),
        ),
        const Divider(indent: 80, endIndent: 16),
        const Padding(
          padding: EdgeInsets.only(left: 80, top: 16, bottom: 8),
          child: Text('Recent updates', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.all(32),
            child: Text('No recent status updates', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
