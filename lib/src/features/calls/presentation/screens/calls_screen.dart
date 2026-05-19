import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/routing/app_routes.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = [
      {'name': 'Alice Johnson', 'type': 'Incoming', 'time': 'Today, 10:30 AM', 'missed': false},
      {'name': 'Bob Smith', 'type': 'Outgoing', 'time': 'Yesterday, 3:15 PM', 'missed': false},
      {'name': 'Charlie Brown', 'type': 'Missed', 'time': 'Yesterday, 11:00 AM', 'missed': true},
      {'name': 'Diana Prince', 'type': 'Incoming', 'time': 'Monday, 9:00 AM', 'missed': false},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFF075E54),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.link, color: Colors.white),
            ),
            title: const Text('Create call link', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text('Share a link for your WhatsApp call'),
            onTap: () {},
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Recent', style: TextStyle(fontSize: 13, color: Color(0xFF8E8E93), fontWeight: FontWeight.w500)),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: calls.length,
            separatorBuilder: (_, __) => const Divider(height: 0, indent: 72),
            itemBuilder: (context, index) {
              final call = calls[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    (call['name'] as String)[0],
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                title: Text(call['name'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Row(
                  children: [
                    Icon(
                      call['type'] == 'Missed'
                          ? Icons.call_missed
                          : call['type'] == 'Incoming'
                              ? Icons.call_received
                              : Icons.call_made,
                      size: 14,
                      color: call['missed'] as bool ? Colors.red : const Color(0xFF075E54),
                    ),
                    const SizedBox(width: 4),
                    Text(call['time'] as String, style: const TextStyle(fontSize: 13)),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.phone, color: Color(0xFF075E54)),
                  onPressed: () => Get.toNamed(AppRoutes.call, arguments: {'name': call['name']}),
                ),
                onTap: () => Get.toNamed(AppRoutes.chat, arguments: {'name': call['name']}),
              );
            },
          ),
        ),
      ],
    );
  }
}
