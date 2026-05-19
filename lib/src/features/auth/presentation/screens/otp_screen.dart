import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/auth/presentation/controllers/auth_controller.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify your phone number',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Obx(() => Text(
              'Enter the 6-digit code sent to\n${auth.phone.value}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
            )),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Dev mode: auto-verifying...',
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
