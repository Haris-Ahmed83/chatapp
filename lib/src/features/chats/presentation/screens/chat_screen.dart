import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

                final bubbleColor = isSent ? const Color(0xFFDCF8C6) : Colors.white;
                return Align(
                  alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
                        bottomLeft: isSent ? const Radius.circular(12) : Radius.zero,
                        bottomRight: isSent ? Radius.zero : const Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 1, offset: const Offset(0, 1)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(msg['content'] as String? ?? '', style: const TextStyle(fontSize: 15)),
                        const SizedBox(height: 2),
                        Text(timeStr, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ],
                    ),
                  ),
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
