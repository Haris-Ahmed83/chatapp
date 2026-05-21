import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chato/src/config/app_config.dart';

class ChatController extends GetxController {
  final chats = <Map<String, dynamic>>[].obs;
  final messages = <Map<String, dynamic>>[].obs;
  final currentChatId = ''.obs;

  void loadChats() {
    final uid = AppConfig.auth.currentUser?.uid;
    if (uid == null) return;

    AppConfig.firestore
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .orderBy('last_message_time', descending: true)
        .snapshots()
        .listen((snapshot) {
      chats.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        final names = data['participant_names'] as Map<String, dynamic>? ?? {};
        String displayName = 'Unknown';
        String otherPhone = '';
        names.forEach((key, value) {
          if (key != uid) {
            displayName = value is String ? value : displayName;
            otherPhone = key;
          }
        });
        data['name'] = displayName;
        data['other_phone'] = otherPhone;
        return data;
      }).toList();
    });
  }

  void loadMessages(String conversationId) {
    currentChatId.value = conversationId;

    AppConfig.firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> createConversation(String contactName, String contactPhone) async {
    final uid = AppConfig.auth.currentUser?.uid;
    if (uid == null) return;
    final doc = await AppConfig.firestore.collection('conversations').add({
      'participants': [uid, contactPhone],
      'participant_names': {uid: 'Me', contactPhone: contactName},
      'created_at': FieldValue.serverTimestamp(),
      'last_message': '',
      'last_message_time': FieldValue.serverTimestamp(),
    });
    currentChatId.value = doc.id;
  }

  Future<void> sendMessage(String conversationId, String content) async {
    final uid = AppConfig.auth.currentUser?.uid;
    if (uid == null || content.trim().isEmpty) return;

    final msgRef = AppConfig.firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .doc();

    await msgRef.set({
      'content': content.trim(),
      'sender_id': uid,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });

    await AppConfig.firestore.collection('conversations').doc(conversationId).update({
      'last_message': content.trim(),
      'last_message_time': FieldValue.serverTimestamp(),
      'last_sender_id': uid,
    });
  }
}
