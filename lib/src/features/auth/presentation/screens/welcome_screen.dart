import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/config/app_config.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/features/auth/presentation/controllers/auth_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  void _checkAuth() {
    try {
      final session = AppConfig.supabase.auth.currentSession;
      if (session != null) {
        Get.find<AuthController>().reloadProfile();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF075E54),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.chat_bubble_rounded,
                  size: 80,
                  color: Colors.white,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Chato',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Secure, fast, and private\nmessaging for everyone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 64),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed(AppRoutes.phoneInput),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Agree and Continue',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'By tapping "Agree and Continue", you agree to our\nTerms of Service and Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
