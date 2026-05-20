import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Get.find<AuthController>().photoUrl.value = file.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Profile Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            GestureDetector(
              onTap: _pickPhoto,
              child: Obx(() => CircleAvatar(
                radius: 56,
                backgroundColor: const Color(0xFF075E54),
                backgroundImage: auth.photoUrl.value.isNotEmpty && auth.photoUrl.value.startsWith('http')
                    ? NetworkImage(auth.photoUrl.value)
                    : null,
                child: auth.photoUrl.value.isEmpty || !auth.photoUrl.value.startsWith('http')
                    ? const Icon(Icons.camera_alt, size: 32, color: Colors.white)
                    : null,
              )),
            ),
            const SizedBox(height: 16),
            const Text('Add profile photo', style: TextStyle(color: Color(0xFF075E54))),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                    if (auth.isLoading.value) return;
                    final name = _nameController.text.trim();
                    if (name.isEmpty) {
                      Get.snackbar('Name required', 'Please enter your name');
                      return;
                    }
                    auth.saveProfile(name);
                  },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF075E54),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Obx(() => auth.isLoading.value
                    ? const SizedBox(
                        width: 24, height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : const Text('SAVE', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
