import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';
import 'package:chato/src/routing/app_routes.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Delete my account'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.warning_amber_rounded, size: 64, color: Colors.red.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          const Text(
            'Delete my account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Deleting your account will:\n\n'
            '- Delete your account from WhatsApp\n'
            '- Delete your message history\n'
            '- Remove you from all groups\n'
            '- Delete your backups',
            style: TextStyle(color: Colors.grey[600], height: 1.5),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Get.dialog(AlertDialog(
                  title: const Text('Delete account?'),
                  content: const Text('Are you sure? This cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        auth.signOut();
                        Get.offAllNamed(AppRoutes.welcome);
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('DELETE MY ACCOUNT'),
            ),
          ),
        ],
      ),
    );
  }
}
