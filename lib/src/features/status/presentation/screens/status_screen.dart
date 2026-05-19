import 'package:flutter/material.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 8),
        ListTile(
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.white),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                    color: Color(0xFF25D366),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          title: const Text('My status', style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text('Tap to add status update'),
          onTap: () {},
        ),
        const Divider(indent: 72),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Recent updates',
            style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93), fontWeight: FontWeight.w500),
          ),
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Text('A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          title: const Text('Alice Johnson', style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text('2 minutes ago'),
          onTap: () {},
        ),
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey[300],
            child: const Text('B', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
          title: const Text('Bob Smith', style: TextStyle(fontWeight: FontWeight.w500)),
          subtitle: const Text('1 hour ago'),
          onTap: () {},
        ),
      ],
    );
  }
}
