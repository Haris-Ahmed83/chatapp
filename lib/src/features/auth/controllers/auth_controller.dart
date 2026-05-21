import 'dart:io';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chato/src/config/app_config.dart';
import 'package:chato/src/routing/app_routes.dart';

class AuthController extends GetxController {
  final phone = ''.obs;
  final displayName = ''.obs;
  final photoUrl = ''.obs;
  final status = 'Hey there! I am using Chato'.obs;
  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final isProfileComplete = false.obs;
  final verificationId = ''.obs;
  final countryCode = '+92'.obs;

  User? get user => AppConfig.auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    try {
      AppConfig.auth.authStateChanges().listen((user) {
        isLoggedIn.value = user != null;
        if (user != null) {
          if (user.displayName != null) displayName.value = user.displayName!;
          if (user.photoURL != null) photoUrl.value = user.photoURL!;
        }
      });
    } catch (_) {}
  }

  String cleanPhone(String raw) {
    return raw.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future<void> sendOtp(String phoneNumber) async {
    isLoading.value = true;
    try {
      phone.value = phoneNumber;
      await AppConfig.auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) async {
          try {
            await AppConfig.auth.signInWithCredential(credential);
          await checkProfile();
        } catch (e) {
            Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
          }
        },
        verificationFailed: (e) {
          isLoading.value = false;
          Get.snackbar('Error', '${e.message}', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
        },
        codeSent: (vid, forceCode) {
          verificationId.value = vid;
          isLoading.value = false;
          Get.toNamed(AppRoutes.otpVerification);
        },
        codeAutoRetrievalTimeout: (vid) {
          isLoading.value = false;
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', '$e', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
    }
  }

  Future<void> verifyOtp(String code) async {
    isLoading.value = true;
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value,
        smsCode: code,
      );
      await AppConfig.auth.signInWithCredential(credential);
      await checkProfile();
    } catch (e) {
      Get.snackbar('Invalid code', 'Please try again');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkProfile() async {
    final user = AppConfig.auth.currentUser;
    if (user == null) return;

    try {
      final doc = await AppConfig.firestore.collection('profiles').doc(user.uid).get();
      final data = doc.data();
      if (doc.exists && data != null && data['display_name'] != null) {
        displayName.value = data['display_name'] as String;
        photoUrl.value = (data['photo_url'] as String?) ?? '';
        status.value = (data['status'] as String?) ?? 'Hey there! I am using Chato';
        isProfileComplete.value = true;
        initPresence();
        Get.offAllNamed(AppRoutes.home);
      } else if (user.displayName != null && user.displayName!.isNotEmpty) {
        displayName.value = user.displayName!;
        isProfileComplete.value = true;
        initPresence();
        Get.offAllNamed(AppRoutes.home);
      } else {
        isProfileComplete.value = false;
        Get.toNamed(AppRoutes.profileSetup);
      }
    } catch (e) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        displayName.value = user.displayName!;
        isProfileComplete.value = true;
        initPresence();
        Get.offAllNamed(AppRoutes.home);
      } else {
        isProfileComplete.value = false;
        Get.toNamed(AppRoutes.profileSetup);
      }
    }
  }

  Future<void> saveProfile(String name) async {
    isLoading.value = true;
    try {
      final user = AppConfig.auth.currentUser;
      if (user == null) {
        Get.snackbar('Error', 'User not signed in. Please try again.');
        return;
      }
      final uid = user.uid;

      String finalPhotoUrl = photoUrl.value;
      if (finalPhotoUrl.isNotEmpty && !finalPhotoUrl.startsWith('http')) {
        try {
          final file = File(finalPhotoUrl);
          if (await file.exists()) {
            final ref = AppConfig.storage.ref('profiles/$uid/photo.jpg');
            await ref.putData(await file.readAsBytes());
            finalPhotoUrl = await ref.getDownloadURL();
            photoUrl.value = finalPhotoUrl;
          }
        } catch (e) {
          finalPhotoUrl = '';
        }
      }

      try {
        await AppConfig.firestore.collection('profiles').doc(uid).set({
          'uid': uid,
          'phone': phone.value,
          'display_name': name,
          'photo_url': finalPhotoUrl,
          'status': status.value,
          'last_seen': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        try {
          await user.updateDisplayName(name);
          await user.reload();
        } catch (e2) {
          Get.snackbar('Error', 'Failed: $e2', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
          return;
        }
      }

      displayName.value = name;
      isProfileComplete.value = true;
      initPresence();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile: $e', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initPresence() async {
    final uid = AppConfig.auth.currentUser?.uid;
    if (uid == null) return;
    final ref = AppConfig.firestore.collection('presences').doc(uid);
    await ref.set({
      'online': true,
      'last_seen': FieldValue.serverTimestamp(),
    });
    ref.onDisconnect().set({
      'online': false,
      'last_seen': FieldValue.serverTimestamp(),
    });
  }

  Future<void> signOut() async {
    final uid = AppConfig.auth.currentUser?.uid;
    if (uid != null) {
      await AppConfig.firestore.collection('presences').doc(uid).set({
        'online': false,
        'last_seen': FieldValue.serverTimestamp(),
      });
    }
    await AppConfig.auth.signOut();
    isProfileComplete.value = false;
    phone.value = '';
    displayName.value = '';
    photoUrl.value = '';
  }
}
