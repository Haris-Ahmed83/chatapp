import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/contacts/controllers/contact_controller.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/features/chats/controllers/chat_controller.dart';

class ContactPickerScreen extends StatelessWidget {
  final String? purpose;
  const ContactPickerScreen({super.key, this.purpose});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContactController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: Text(purpose == 'call' ? 'Select contact' : 'New chat'),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.contacts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('No contacts with this app', style: TextStyle(color: Colors.grey)),
                SizedBox(height: 8),
                Text('Invite friends to WhatsApp do!', style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.separated(
          itemCount: controller.contacts.length,
          separatorBuilder: (_, __) => const Divider(indent: 80, endIndent: 16),
          itemBuilder: (context, index) {
            final c = controller.contacts[index];
            final name = c['name'] ?? 'Unknown';
            final phone = c['phone'] ?? '';
            final photoUrl = c['photo_url'] ?? '';
            final uid = c['uid'] ?? '';

            return ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF075E54),
                backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                child: photoUrl.isEmpty
                    ? Text(
                        (name as String)[0].toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      )
                    : null,
              ),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: Text(phone, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              onTap: () async {
                if (purpose == 'call') {
                  Get.toNamed(AppRoutes.call, arguments: {'name': name, 'phone': phone, 'uid': uid});
                } else {
                  final chatController = Get.find<ChatController>();
                  await chatController.createConversation(name, uid);
                  final convoId = chatController.currentChatId.value;
                  if (convoId.isNotEmpty) {
                    Get.back();
                    Get.toNamed(AppRoutes.chat, arguments: {'name': name, 'id': convoId});
                  }
                }
              },
            );
          },
        );
      }),
    );
  }
}
