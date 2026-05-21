import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/routing/app_routes.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.phone, size: 80, color: Color(0xFF25D366)),
          const SizedBox(height: 16),
          const Text('No call history', style: TextStyle(fontSize: 18, color: Colors.grey)),
          const SizedBox(height: 8),
          const Text('Your call history will appear here', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed(AppRoutes.contactPicker, arguments: {'purpose': 'call'});
            },
            icon: const Icon(Icons.phone),
            label: const Text('Start a call'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ],
      ),
    );
  }
}
