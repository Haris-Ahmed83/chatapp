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
      if (controller.chats.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 80, color: Color(0xFF25D366)),
              SizedBox(height: 16),
              Text('No chats yet', style: TextStyle(fontSize: 18, color: Colors.grey)),
              SizedBox(height: 8),
              Text('Tap the button below to start a chat', style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: controller.chats.length,
        separatorBuilder: (_, __) => const Divider(indent: 80, endIndent: 16),
        itemBuilder: (context, index) {
          final chat = controller.chats[index];
          final name = chat['name'] ?? 'Unknown';
          final lastMsg = chat['last_message'] ?? '';
          final photo = chat['photo_url'] ?? '';

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
              Get.find<ChatController>().loadMessages(chat['id']);
              Get.toNamed(AppRoutes.chat, arguments: {'name': name, 'id': chat['id']});
            },
          );
        },
      );
    });
  }
}
