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

  int? _forceCode;

  User? get user => AppConfig.auth.currentUser;

  @override
  void onInit() {
    super.onInit();
    AppConfig.auth.authStateChanges().listen((user) {
      isLoggedIn.value = user != null;
      if (user != null) {
        if (user.displayName != null) displayName.value = user.displayName!;
        if (user.photoURL != null) photoUrl.value = user.photoURL!;
      }
    });
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
          await AppConfig.auth.signInWithCredential(credential);
          Get.offAllNamed(AppRoutes.home);
        },
        verificationFailed: (e) {
          Get.snackbar('Error', e.message ?? 'Verification failed');
        },
        codeSent: (vid, forceCode) {
          verificationId.value = vid;
          _forceCode = forceCode;
          Get.toNamed(AppRoutes.otpVerification);
        },
        codeAutoRetrievalTimeout: (vid) {},
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP');
    } finally {
      isLoading.value = false;
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
      await _checkProfile();
    } catch (e) {
      Get.snackbar('Invalid code', 'Please try again');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkProfile() async {
    final uid = AppConfig.auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final doc = await AppConfig.firestore.collection('profiles').doc(uid).get();
      if (doc.exists && doc.data()?['display_name'] != null) {
        displayName.value = doc['display_name'];
        photoUrl.value = doc['photo_url'] ?? '';
        status.value = doc['status'] ?? '';
        isProfileComplete.value = true;
        Get.offAllNamed(AppRoutes.home);
      } else {
        isProfileComplete.value = false;
        Get.toNamed(AppRoutes.profileSetup);
      }
    } catch (_) {
      Get.toNamed(AppRoutes.profileSetup);
    }
  }

  Future<void> saveProfile(String name) async {
    isLoading.value = true;
    try {
      final uid = AppConfig.auth.currentUser?.uid;
      if (uid == null) return;

      await AppConfig.firestore.collection('profiles').doc(uid).set({
        'uid': uid,
        'phone': phone.value,
        'display_name': name,
        'photo_url': photoUrl.value,
        'status': status.value,
        'last_seen': FieldValue.serverTimestamp(),
      });

      displayName.value = name;
      isProfileComplete.value = true;
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await AppConfig.auth.signOut();
    isProfileComplete.value = false;
    phone.value = '';
    displayName.value = '';
    photoUrl.value = '';
  }
}
