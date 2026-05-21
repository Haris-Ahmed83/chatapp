import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestInfoScreen extends StatelessWidget {
  const RequestInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Request account info'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.folder_outlined, size: 64, color: const Color(0xFF075E54).withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text(
            'Request account information',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'You can request a report of your account information and settings. It may take up to 3 days to generate.',
            style: TextStyle(color: Colors.grey[600], height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Get.snackbar('Request submitted',
                'Your account info report will be ready in up to 3 days',
                snackPosition: SnackPosition.BOTTOM),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF075E54),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('REQUEST REPORT'),
            ),
          ),
        ],
      ),
    );
  }
}
