import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/features/chats/presentation/controllers/chat_controller.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Obx(() {
      if (controller.chats.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text('No chats yet', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
              const SizedBox(height: 8),
              Text('Start a conversation!', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: controller.chats.length,
        separatorBuilder: (_, __) => const Divider(height: 0, indent: 72),
        itemBuilder: (context, index) {
          final chat = controller.chats[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Text(
                (chat['name'] as String? ?? '?')[0].toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
            title: Text(
              chat['name'] as String? ?? 'Unknown',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              chat['last_message'] as String? ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: Text(
              _formatTime(chat['last_message_at'] as String? ?? ''),
              style: const TextStyle(fontSize: 12, color: Color(0xFF8E8E93)),
            ),
            onTap: () => Get.toNamed(AppRoutes.chat, arguments: {
              'conversation_id': chat['id'],
              'name': chat['name'],
            }),
          );
        },
      );
    });
  }

  String _formatTime(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.parse(iso);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays == 0) {
        return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } else if (diff.inDays == 1) {
        return 'Yesterday';
      } else {
        return '${dt.day}/${dt.month}';
      }
    } catch (_) {
      return '';
    }
  }
}
