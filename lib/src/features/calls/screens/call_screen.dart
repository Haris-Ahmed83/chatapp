import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/calls/controllers/call_controller.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CallController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0B141A),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              'Calling...',
              style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
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
                _buildAction(Icons.mic_off, 'Mute'),
                _buildAction(Icons.volume_up, 'Speaker'),
                GestureDetector(
                  onTap: () {
                    controller.endCall();
                    Get.back();
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.call_end, color: Colors.white, size: 32),
                  ),
                ),
                _buildAction(Icons.keyboard, 'Keypad'),
                _buildAction(Icons.add, 'Add call'),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAction(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
      ],
    );
  }
}
