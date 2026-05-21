import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool _twoStep = false;
  String? _pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Security'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Two-step verification'),
            subtitle: Text(_twoStep ? 'PIN is set' : 'Set a PIN to secure your account',
              style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            value: _twoStep,
            activeColor: const Color(0xFF075E54),
            onChanged: (v) {
              if (v) {
                _showPinSetup();
              } else {
                setState(() { _twoStep = false; _pin = null; });
              }
            },
          ),
          if (_twoStep)
            ListTile(
              leading: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF075E54).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock, color: Color(0xFF075E54), size: 20),
              ),
              title: const Text('Change PIN'),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: _showPinSetup,
            ),
          const Divider(),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF075E54).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.security, color: Color(0xFF075E54), size: 20),
            ),
            title: const Text('Security notifications'),
            subtitle: Text('Show security notifications', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => Get.snackbar('Security notifications', 'Feature coming soon',
              snackPosition: SnackPosition.BOTTOM),
          ),
        ],
      ),
    );
  }

  void _showPinSetup() {
    final controller = TextEditingController(text: _pin);
    Get.dialog(AlertDialog(
      title: const Text('Set a PIN'),
      content: TextField(
        controller: controller,
        obscureText: true,
        maxLength: 6,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter 6-digit PIN',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            final pin = controller.text.trim();
            if (pin.length == 6) {
              setState(() { _twoStep = true; _pin = pin; });
              Get.back();
              Get.snackbar('Success', 'Two-step verification enabled',
                snackPosition: SnackPosition.BOTTOM);
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF075E54)),
          child: const Text('Save', style: TextStyle(color: Colors.white)),
        ),
      ],
    ));
  }
}
