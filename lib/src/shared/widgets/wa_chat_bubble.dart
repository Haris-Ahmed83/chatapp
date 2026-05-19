import 'package:flutter/material.dart';

class WaChatBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isSent;
  final bool isRead;

  const WaChatBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isSent,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSent ? const Color(0xFFDCF8C5) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isSent ? const Radius.circular(16) : Radius.zero,
            bottomRight: isSent ? Radius.zero : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF8E8E93)),
                ),
                if (isSent) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: isRead ? const Color(0xFF34B7F1) : const Color(0xFF8E8E93),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
