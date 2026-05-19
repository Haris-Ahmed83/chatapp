import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map? ?? {};
    final name = args['name'] as String? ?? 'Unknown';

    return Scaffold(
      backgroundColor: const Color(0xFF111B21),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            CircleAvatar(
              radius: 56,
              backgroundColor: Colors.grey[700],
              child: Text(
                name[0],
                style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              name,
              style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Text(
              'Calling...',
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CallActionButton(icon: Icons.volume_up, label: 'Speaker', onPressed: () {}),
                _CallActionButton(icon: Icons.mic_off, label: 'Mute', onPressed: () {}),
                _CallActionButton(
                  icon: Icons.call_end,
                  label: 'End',
                  color: Colors.redAccent,
                  size: 20,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final double size;
  final VoidCallback onPressed;

  const _CallActionButton({
    required this.icon,
    required this.label,
    this.color,
    this.size = 28,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: color?.withOpacity(0.2) ?? Colors.grey[800],
          child: IconButton(
            icon: Icon(icon, color: color ?? Colors.white, size: size),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}
