import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chato/src/config/app_config.dart';
import 'package:chato/src/routing/app_routes.dart';

class AuthController extends GetxController {
  final phone = ''.obs;
  final displayName = ''.obs;
  final photoUrl = ''.obs;
  final isLoading = false.obs;
  final isAuthenticated = false.obs;
  final isProfileComplete = false.obs;
  final countryCode = '+91'.obs;

  late final StreamSubscription<AuthState> _authSub;

  @override
  void onInit() {
    super.onInit();
    try {
      _authSub = AppConfig.supabase.auth.onAuthStateChange.listen((data) {
        final session = data.session;
        if (session != null) {
          isAuthenticated.value = true;
          _checkProfile(session.user.id);
        } else {
          isAuthenticated.value = false;
          isProfileComplete.value = false;
        }
      });
    } catch (_) {
      debugPrint('Auth listener setup failed');
    }
  }

  @override
  void onClose() {
    _authSub.cancel();
    super.onClose();
  }

  Future<void> _checkProfile(String userId) async {
    try {
      final response = await AppConfig.supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response != null) {
        displayName.value = response['display_name'] ?? '';
        photoUrl.value = response['photo_url'] ?? '';
        isProfileComplete.value = true;
        Get.offAllNamed(AppRoutes.home);
      } else {
        isProfileComplete.value = false;
      }
    } catch (_) {
      isProfileComplete.value = false;
    }
  }

  String _phoneToEmail(String phone) {
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return '$digits@chato.dev';
  }

  String _phoneToPassword(String phone) {
    return 'chato${phone.replaceAll(RegExp(r'[^0-9]'), '')}';
  }

  Future<bool> loginWithPhone(String phoneNumber) async {
    isLoading.value = true;
    try {
      phone.value = phoneNumber;
      final email = _phoneToEmail(phoneNumber);
      final password = _phoneToPassword(phoneNumber);

      final signInRes = await AppConfig.supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return signInRes.user != null;
    } on AuthException catch (e) {
      debugPrint('signIn failed: ${e.message}');
      try {
        final signUpRes = await AppConfig.supabase.auth.signUp(
          email: _phoneToEmail(phoneNumber),
          password: _phoneToPassword(phoneNumber),
        );
        if (signUpRes.user != null && signUpRes.session != null) {
          return true;
        }
        if (signUpRes.user != null && signUpRes.session == null) {
          await Future.delayed(const Duration(seconds: 1));
          final retry = await AppConfig.supabase.auth.signInWithPassword(
            email: _phoneToEmail(phoneNumber),
            password: _phoneToPassword(phoneNumber),
          );
          if (retry.user != null) return true;
          Get.snackbar(
            'Cannot log in',
            'Supabase "Confirm email" is ON. Go to Supabase Dashboard → Authentication → Settings → Turn OFF "Confirm email".\n\n'
            'Phone: $phoneNumber',
            duration: const Duration(seconds: 8),
            snackPosition: SnackPosition.BOTTOM,
          );
          return false;
        }
        return false;
      } on AuthException catch (e) {
        Get.snackbar('Error', e.message);
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in. Please try again.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile(String name) async {
    isLoading.value = true;
    try {
      displayName.value = name;
      final user = AppConfig.supabase.auth.currentUser;
      if (user != null) {
        await AppConfig.supabase.from('profiles').upsert({
          'id': user.id,
          'phone': phone.value,
          'display_name': name,
          'status': 'Hey there! I am using Chato',
          'last_seen': DateTime.now().toIso8601String(),
        });
        isProfileComplete.value = true;
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reloadProfile() async {
    final user = AppConfig.supabase.auth.currentUser;
    if (user != null) {
      await _checkProfile(user.id);
    }
  }

  Future<void> signOut() async {
    await AppConfig.supabase.auth.signOut();
    isAuthenticated.value = false;
    isProfileComplete.value = false;
    phone.value = '';
    displayName.value = '';
    photoUrl.value = '';
  }
}
