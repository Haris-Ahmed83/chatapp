import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/status/controllers/status_controller.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatusController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF25D366),
              ),
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
            title: const Text('My status', style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: const Text('Tap to add status update'),
            onTap: () => controller.pickAndUploadStatus(),
          ),
          const Divider(indent: 80, endIndent: 16),
          const Padding(
            padding: EdgeInsets.only(left: 80, top: 16, bottom: 8),
            child: Text('Recent updates', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey)),
          ),
          Obx(() {
            if (controller.myStatuses.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No recent status updates', style: TextStyle(color: Colors.grey)),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.myStatuses.length,
              itemBuilder: (_, i) {
                final s = controller.myStatuses[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF25D366),
                    backgroundImage: s['image_url'] != null && (s['image_url'] as String).isNotEmpty
                        ? NetworkImage(s['image_url'] as String)
                        : null,
                    child: s['image_url'] == null || (s['image_url'] as String).isEmpty
                        ? const Icon(Icons.image, color: Colors.white)
                        : null,
                  ),
                  title: Text(s['caption'] ?? 'Status', style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text('${s['timestamp'] ?? ''}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
