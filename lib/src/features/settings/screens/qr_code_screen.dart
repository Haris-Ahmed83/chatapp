import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';
import 'package:chato/src/config/app_config.dart';

class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () => Get.snackbar('Scan QR', 'Open camera to scan QR code',
              snackPosition: SnackPosition.BOTTOM),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              final name = auth.displayName.value.isNotEmpty ? auth.displayName.value : 'User';
              final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
              return CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFF075E54),
                child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 36)),
              );
            }),
            const SizedBox(height: 16),
            Obx(() => Text(auth.displayName.value.isNotEmpty ? auth.displayName.value : 'User',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600))),
            Obx(() => Text(auth.phone.value.isNotEmpty ? auth.phone.value : '+92 XXXXX XXXXX',
              style: TextStyle(color: Colors.grey[600]))),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Obx(() {
                final uid = AppConfig.auth.currentUser?.uid ?? '';
                final data = 'whatsapp:${auth.phone.value.replaceAll("+", "")}';
                return QrImageView(
                  data: data,
                  version: QrVersions.auto,
                  size: 200,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: Color(0xFF075E54),
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: Color(0xFF075E54),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Text('Scan this code to add contact', style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}
