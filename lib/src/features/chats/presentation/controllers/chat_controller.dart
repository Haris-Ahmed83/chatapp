import 'package:get/get.dart';
import 'package:chato/src/config/app_config.dart';

class ChatController extends GetxController {
  final chats = <Map<String, dynamic>>[].obs;
  final currentMessages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadChats();
  }

  Future<void> loadChats() async {
    final userId = AppConfig.supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final participantIds = await AppConfig.supabase
          .from('conversation_participants')
          .select('conversation_id')
          .eq('user_id', userId);

      if (participantIds.isEmpty) return;

      final ids = participantIds.map((e) => e['conversation_id'] as String).toList();

      final data = await AppConfig.supabase
          .from('conversations')
          .select()
          .inFilter('id', ids)
          .order('last_message_at', ascending: false);

      chats.value = data;
    } catch (_) {}
  }

  Future<void> loadMessages(String conversationId) async {
    try {
      final data = await AppConfig.supabase
          .from('messages')
          .select()
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: true);

      currentMessages.value = data;
    } catch (_) {}
  }

  Future<void> sendMessage(String conversationId, String content) async {
    final userId = AppConfig.supabase.auth.currentUser?.id;
    if (userId == null || conversationId.isEmpty) return;

    try {
      await AppConfig.supabase.from('messages').insert({
        'conversation_id': conversationId,
        'sender_id': userId,
        'content': content,
        'type': 'text',
      });

      await AppConfig.supabase
          .from('conversations')
          .update({'last_message_at': DateTime.now().toIso8601String()})
          .eq('id', conversationId);

      loadMessages(conversationId);
    } catch (_) {}
  }
}
