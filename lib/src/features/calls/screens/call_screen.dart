import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/calls/controllers/call_controller.dart';

class CallScreen extends StatefulWidget {
  const CallScreen({super.key});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final controller = Get.find<CallController>();
  final args = Get.arguments as Map<String, dynamic>?;

  @override
  void initState() {
    super.initState();
    final name = args?['name'] ?? 'Unknown';
    controller.startCall(name as String);
  }

  @override
  void dispose() {
    controller.endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = args?['name'] ?? 'Unknown';

    return Scaffold(
      backgroundColor: const Color(0xFF0B141A),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white24,
              child: Text(
                (name as String)[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 48),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              controller.callDuration.value,
              style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.7)),
            )),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Obx(() => _buildAction(
                  controller.isMuted.value ? Icons.mic : Icons.mic_off,
                  controller.isMuted.value ? 'Unmute' : 'Mute',
                  () => controller.toggleMute(),
                )),
                Obx(() => _buildAction(
                  controller.isSpeakerOn.value ? Icons.volume_up : Icons.volume_down,
                  controller.isSpeakerOn.value ? 'Speaker on' : 'Speaker',
                  () => controller.toggleSpeaker(),
                )),
                GestureDetector(
                  onTap: () {
                    controller.endCall();
                    Get.back();
                  },
                  child: Container(
                    width: 64, height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.red, shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                  ),
                ),
                _buildAction(Icons.keyboard, 'Keypad', () {}),
                _buildAction(Icons.add, 'Add call', () {}),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1), shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}
