import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final _phoneController = TextEditingController();

  static const _countries = [
    ('Pakistan', '+92'),
    ('India', '+91'),
    ('United States', '+1'),
    ('United Kingdom', '+44'),
    ('Australia', '+61'),
    ('Bangladesh', '+880'),
    ('Brazil', '+55'),
    ('Canada', '+1'),
    ('China', '+86'),
    ('Egypt', '+20'),
    ('France', '+33'),
    ('Germany', '+49'),
    ('Indonesia', '+62'),
    ('Iran', '+98'),
    ('Iraq', '+964'),
    ('Italy', '+39'),
    ('Japan', '+81'),
    ('Malaysia', '+60'),
    ('Mexico', '+52'),
    ('Morocco', '+212'),
    ('Nepal', '+977'),
    ('Netherlands', '+31'),
    ('Nigeria', '+234'),
    ('Philippines', '+63'),
    ('Russia', '+7'),
    ('Saudi Arabia', '+966'),
    ('Singapore', '+65'),
    ('South Africa', '+27'),
    ('South Korea', '+82'),
    ('Spain', '+34'),
    ('Sri Lanka', '+94'),
    ('Sweden', '+46'),
    ('Switzerland', '+41'),
    ('Thailand', '+66'),
    ('Turkey', '+90'),
    ('UAE', '+971'),
    ('Ukraine', '+380'),
    ('Vietnam', '+84'),
  ];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Icon(Icons.chat_bubble_outline, size: 48, color: Color(0xFF075E54)),
            const SizedBox(height: 16),
            const Text(
              'Enter your phone number',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Chato will send an SMS message to verify your phone number.\nEnter your country code and phone number:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 130),
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: auth.countryCode.value,
                      borderRadius: BorderRadius.circular(4),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      isDense: true,
                      items: _countries.map((c) => DropdownMenuItem(
                        value: c.$2,
                        child: Text('${c.$2} (${c.$1})', style: const TextStyle(fontSize: 13)),
                      )).toList(),
                      onChanged: (v) {
                        if (v != null) auth.countryCode.value = v;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: auth.isLoading.value
                    ? null
                    : () {
                        final digits = _phoneController.text.trim();
                        if (digits.length < 6) {
                          Get.snackbar('Invalid', 'Please enter a valid phone number.');
                          return;
                        }
                        final phone = '${auth.countryCode.value}$digits';
                        auth.sendOtp(phone);
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
                    : const Text('NEXT', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
