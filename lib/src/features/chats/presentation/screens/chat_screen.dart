import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/shared/widgets/wa_chat_bubble.dart';
import 'package:chato/src/features/chats/presentation/controllers/chat_controller.dart';
import 'package:chato/src/config/app_config.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  late String conversationId;
  late String contactName;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map? ?? {};
    conversationId = args['conversation_id'] as String? ?? '';
    contactName = args['name'] as String? ?? 'Unknown';

    if (conversationId.isNotEmpty) {
      Get.find<ChatController>().loadMessages(conversationId);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    Get.find<ChatController>().sendMessage(conversationId, text);
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();
    final userId = AppConfig.supabase.auth.currentUser?.id ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: Text(
                contactName[0],
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(contactName, style: const TextStyle(fontSize: 17)),
                const Text(
                  'online',
                  style: TextStyle(fontSize: 12, color: Color(0xFFB0B0B0)),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.phone), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: controller.currentMessages.length,
              itemBuilder: (context, index) {
                final msg = controller.currentMessages[index];
                final isSent = msg['sender_id'] == userId;
                final time = (msg['created_at'] as String?) ?? '';
                final timeStr = time.isNotEmpty ? time.substring(11, 16) : '';

                return WaChatBubble(
                  message: msg['content'] as String? ?? '',
                  time: timeStr,
                  isSent: isSent,
                );
              },
            )),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    color: Colors.grey[600],
                    onPressed: () {},
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF075E54)),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
