import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';
import 'package:chato/src/features/settings/screens/privacy_screen.dart';
import 'package:chato/src/features/settings/screens/security_screen.dart';
import 'package:chato/src/features/settings/screens/change_number_screen.dart';
import 'package:chato/src/features/settings/screens/request_info_screen.dart';
import 'package:chato/src/features/settings/screens/delete_account_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Account'),
      ),
      body: ListView(
        children: [
          Obx(() {
            final name = auth.displayName.value;
            final letter = name.isNotEmpty ? name[0].toUpperCase() : '?';
            return ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF075E54),
                child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 24)),
              ),
              title: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
              subtitle: const Text('Tap to change'),
              onTap: () => _showProfileEditDialog(context, auth),
            );
          }),
          ...[
            _item(Icons.lock_outline, 'Privacy', 'Last seen, profile photo, about',
              () => Get.to(() => const PrivacyScreen())),
            _item(Icons.security, 'Security', 'Two-step verification',
              () => Get.to(() => const SecurityScreen())),
            _item(Icons.phone_android, 'Change number', 'Change your phone number',
              () => Get.to(() => const ChangeNumberScreen())),
            _item(Icons.folder_outlined, 'Request account info', '',
              () => Get.to(() => const RequestInfoScreen())),
            _item(Icons.delete_outline, 'Delete my account', '',
              () => Get.to(() => const DeleteAccountScreen())),
          ],
        ],
      ),
    );
  }

  Widget _item(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF075E54).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: const Color(0xFF075E54), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey[600])) : null,
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () => Get.snackbar(title, subtitle.isEmpty ? 'Not yet available' : subtitle,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showProfileEditDialog(BuildContext context, AuthController auth) {
    final nameController = TextEditingController(text: auth.displayName.value);
    final statusController = TextEditingController(text: auth.status.value);

    Get.dialog(AlertDialog(
      title: const Text('Edit profile'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () async {
                final file = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (file != null) {
                  auth.photoUrl.value = file.path;
                }
              },
              child: Obx(() {
                final photo = auth.photoUrl.value;
                ImageProvider? image;
                if (photo.startsWith('http')) {
                  image = NetworkImage(photo);
                } else if (photo.isNotEmpty) {
                  image = FileImage(File(photo));
                }
                return CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF075E54),
                  backgroundImage: image,
                  child: image == null ? const Icon(Icons.camera_alt, size: 28, color: Colors.white) : null,
                );
              }),
            ),
            const SizedBox(height: 8),
            Text('Tap to change photo', style: TextStyle(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final name = nameController.text.trim();
            if (name.isNotEmpty) {
              auth.displayName.value = name;
              auth.status.value = statusController.text.trim();
              auth.saveProfile(name);
            }
            Get.back();
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF075E54)),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}
