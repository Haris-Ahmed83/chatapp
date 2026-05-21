import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chato/src/features/chats/controllers/chat_controller.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/config/app_config.dart';
import 'dart:io';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _audioRecorder = AudioRecorder();
  final _audioPlayer = AudioPlayer();
  final _isRecording = false.obs;
  String _onlineStatus = 'offline';
  String? _recordingPath;

  @override
  void initState() {
    super.initState();
    _listenPresence();
  }

  void _listenPresence() {
    final args = Get.arguments as Map<String, dynamic>?;
    final otherUid = args?['other_uid'] as String? ?? '';
    if (otherUid.isEmpty) return;
    AppConfig.firestore.collection('presences').doc(otherUid).snapshots().listen((snap) {
      if (!mounted) return;
      final data = snap.data();
      final online = data?['online'] as bool? ?? false;
      setState(() => _onlineStatus = online ? 'online' : 'offline');
    });
  }

  Future<void> _startRecording() async {
    try {
      final path = '${Directory.systemTemp.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
      await _audioRecorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      _recordingPath = path;
      _isRecording.value = true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to start recording: $e');
    }
  }

  Future<void> _stopRecording(String chatId) async {
    if (!_isRecording.value) return;
    _isRecording.value = false;
    try {
      final path = await _audioRecorder.stop();
      if (path == null) return;
      final chatController = Get.find<ChatController>();
      final uid = AppConfig.auth.currentUser?.uid ?? '';
      final fileName = 'voice/$chatId/${DateTime.now().millisecondsSinceEpoch}.m4a';
      final ref = AppConfig.storage.ref(fileName);
      await ref.putFile(File(path));
      final url = await ref.getDownloadURL();
      final msgRef = AppConfig.firestore
          .collection('conversations')
          .doc(chatId)
          .collection('messages')
          .doc();
      await msgRef.set({
        'content': url,
        'sender_id': uid,
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'voice',
      });
      await AppConfig.firestore.collection('conversations').doc(chatId).update({
        'last_message': 'Voice message',
        'last_message_time': FieldValue.serverTimestamp(),
        'last_sender_id': uid,
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to send voice: $e');
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    final chatName = args?['name'] ?? 'Chat';
    final chatId = args?['id'] as String? ?? '';
    final controller = Get.find<ChatController>();
    final userId = AppConfig.auth.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFFECE5DD),
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white24,
              child: Text(
                (chatName as String)[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chatName, style: const TextStyle(fontSize: 17)),
                Text(_onlineStatus, style: TextStyle(fontSize: 12, color: _onlineStatus == 'online'
                  ? const Color(0xFF25D366)
                  : Colors.white.withValues(alpha: 0.7))),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () => Get.snackbar('Video call', 'Coming soon', snackPosition: SnackPosition.BOTTOM),
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () => Get.toNamed(AppRoutes.call, arguments: {
              'name': chatName,
              'other_uid': args?['other_uid'] ?? '',
            }),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (v) {
              if (v == 'view') {
                Get.toNamed(AppRoutes.contactDetail, arguments: {
                  'name': chatName,
                  'other_uid': args?['other_uid'] ?? '',
                });
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'view', child: Text('View contact')),
              const PopupMenuItem(value: 'media', child: Text('Media, links, and docs')),
              const PopupMenuItem(value: 'search', child: Text('Search in chat')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final msgs = controller.messages;
              if (msgs.isEmpty) {
                return const Center(child: Text('No messages yet', style: TextStyle(color: Colors.grey)));
              }
              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  final msg = msgs[index];
                  final isSent = msg['sender_id'] == userId;
                  final type = msg['type'] as String? ?? 'text';
                  final content = msg['content'] as String? ?? '';
                  final ts = msg['timestamp'] as Timestamp?;
                  final time = ts != null
                      ? '${ts.toDate().hour.toString().padLeft(2, '0')}:${ts.toDate().minute.toString().padLeft(2, '0')}'
                      : '';

                  return Align(
                    alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.fromLTRB(12, 8, 8, 4),
                      decoration: BoxDecoration(
                        color: isSent ? const Color(0xFFDCF8C6) : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(8),
                          topRight: const Radius.circular(8),
                          bottomLeft: isSent ? const Radius.circular(8) : Radius.zero,
                          bottomRight: isSent ? Radius.zero : const Radius.circular(8),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 1,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (type == 'voice')
                            _VoiceBubble(url: content)
                          else
                            Text(content, style: const TextStyle(fontSize: 15)),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                              if (isSent) ...[
                                const SizedBox(width: 4),
                                Icon(Icons.done_all, size: 14, color: Colors.grey[500]),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
                    onPressed: () {},
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        filled: true,
                        fillColor: const Color(0xFFF0F0F0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (_isRecording.value) {
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.fiber_manual_record, color: Colors.red, size: 28),
                      );
                    }
                    return GestureDetector(
                      onLongPress: () => _startRecording(),
                      onLongPressUp: () => _stopRecording(chatId),
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.mic, color: Colors.grey, size: 28),
                      ),
                    );
                  }),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF075E54)),
                    onPressed: () {
                      final text = _messageController.text.trim();
                      if (text.isNotEmpty) {
                        controller.sendMessage(chatId, text);
                        _messageController.clear();
                      }
                    },
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

class _VoiceBubble extends StatefulWidget {
  final String url;
  const _VoiceBubble({required this.url});

  @override
  State<_VoiceBubble> createState() => _VoiceBubbleState();
}

class _VoiceBubbleState extends State<_VoiceBubble> {
  final _player = AudioPlayer();
  bool _playing = false;
  bool _loaded = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (_playing) {
          await _player.stop();
          setState(() => _playing = false);
        } else {
          await _player.play(UrlSource(widget.url));
          setState(() => _playing = true);
          _player.onPlayerComplete.listen((_) {
            if (mounted) setState(() => _playing = false);
          });
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_playing ? Icons.pause_circle_filled : Icons.play_circle_filled,
            color: const Color(0xFF075E54), size: 28),
          const SizedBox(width: 8),
          const Text('Voice message', style: TextStyle(color: Color(0xFF075E54))),
        ],
      ),
    );
  }
}
