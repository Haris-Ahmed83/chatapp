import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/chats/controllers/chat_controller.dart';
import 'package:chato/src/routing/app_routes.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ChatController>().loadChats();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Obx(() {
      final query = controller.searchQuery.value.toLowerCase().trim();
      final chats = query.isEmpty
          ? controller.chats
          : controller.chats.where((c) {
              final name = (c['name'] as String? ?? '').toLowerCase();
              final lastMsg = (c['last_message'] as String? ?? '').toLowerCase();
              return name.contains(query) || lastMsg.contains(query);
            }).toList();

      if (chats.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                query.isNotEmpty ? Icons.search_off : Icons.chat_bubble_outline,
                size: 80, color: const Color(0xFF25D366),
              ),
              const SizedBox(height: 16),
              Text(
                query.isNotEmpty ? 'No chats found' : 'No chats yet',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              if (query.isEmpty) ...[
                const SizedBox(height: 8),
                const Text('Tap the button below to start a chat', style: TextStyle(color: Colors.grey)),
              ],
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (_, __) => const Divider(indent: 80, endIndent: 16),
        itemBuilder: (context, index) {
          final chat = chats[index];
          final name = chat['name'] ?? 'Unknown';
          final lastMsg = chat['last_message'] ?? '';
          final photo = chat['photo_url'] ?? '';
          final otherUid = chat['other_uid'] ?? '';

          return ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF075E54),
              backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
              child: photo.isEmpty ? Text(
                (name as String)[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ) : null,
            ),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(lastMsg, maxLines: 1, overflow: TextOverflow.ellipsis),
            onTap: () {
              controller.loadMessages(chat['id']);
              Get.toNamed(AppRoutes.chat, arguments: {'name': name, 'id': chat['id'], 'other_uid': otherUid});
            },
          );
        },
      );
    });
  }
}
