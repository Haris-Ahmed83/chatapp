import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Profile Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {}
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.grey[200],
                    child: Icon(Icons.camera_alt, size: 32, color: Colors.grey[600]),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF25D366),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 8),
            Text(
              'This is the name that others will see.',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const Spacer(),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: auth.isLoading.value
                    ? null
                    : () async {
                        final name = _nameController.text.trim();
                        if (name.isEmpty) {
                          Get.snackbar('Required', 'Please enter your name.');
                          return;
                        }
                        await auth.saveProfile(name);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF075E54),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: auth.isLoading.value
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save', style: TextStyle(fontSize: 16)),
              ),
            )),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
