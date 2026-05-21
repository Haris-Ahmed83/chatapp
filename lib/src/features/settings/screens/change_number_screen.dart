import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeNumberScreen extends StatefulWidget {
  const ChangeNumberScreen({super.key});

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {
  final _oldCodeController = TextEditingController(text: '+92');
  final _oldPhoneController = TextEditingController();
  final _newCodeController = TextEditingController(text: '+92');
  final _newPhoneController = TextEditingController();

  @override
  void dispose() {
    _oldCodeController.dispose();
    _oldPhoneController.dispose();
    _newCodeController.dispose();
    _newPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Change number'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Your old number', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Enter your current phone number', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(width: 80, child: TextField(
                controller: _oldCodeController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '+92'),
              )),
              const SizedBox(width: 12),
              Expanded(child: TextField(
                controller: _oldPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '3XX XXXXXXX'),
              )),
            ],
          ),
          const SizedBox(height: 32),
          Text('Your new number', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Enter your new phone number', style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(width: 80, child: TextField(
                controller: _newCodeController,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '+92'),
              )),
              const SizedBox(width: 12),
              Expanded(child: TextField(
                controller: _newPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: '3XX XXXXXXX'),
              )),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => Get.snackbar('Change number',
                'Verification will be sent to your new number',
                snackPosition: SnackPosition.BOTTOM),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25D366),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('NEXT', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
