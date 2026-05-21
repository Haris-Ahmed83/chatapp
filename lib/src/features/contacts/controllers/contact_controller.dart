import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chato/src/config/app_config.dart';

class ContactController extends GetxController {
  final contacts = <Map<String, String>>[].obs;
  final loading = false.obs;
  final permissionGranted = false.obs;

  String _normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  Future<void> loadContacts() async {
    loading.value = true;
    try {
      final status = await Permission.contacts.request();
      if (status.isGranted) {
        permissionGranted.value = true;
        final raw = await fc.FlutterContacts.getContacts(
          withProperties: true,
          withThumbnail: false,
        );

        final profilesSnap = await AppConfig.firestore.collection('profiles').get();
        final appUsers = profilesSnap.docs.map((d) => d.data()).toList();

        final matched = <Map<String, String>>[];
        for (final c in raw) {
          final phone = c.phones.isNotEmpty ? _normalizePhone(c.phones.first.number) : '';
          if (phone.isEmpty) continue;

          final appUser = appUsers.cast<Map<String, dynamic>>().firstWhere(
            (u) {
              final stored = _normalizePhone(u['phone'] as String? ?? '');
              return stored.contains(phone.replaceAll('+', '')) || phone.contains(stored.replaceAll('+', ''));
            },
            orElse: () => <String, dynamic>{},
          );

          if (appUser.isNotEmpty) {
            matched.add({
              'name': c.displayName.isNotEmpty ? c.displayName : (appUser['display_name'] as String? ?? 'Unknown'),
              'phone': phone,
              'photo_url': (appUser['photo_url'] as String? ?? ''),
              'uid': (appUser['uid'] as String? ?? ''),
            });
          }
        }

        contacts.value = matched;
      } else {
        permissionGranted.value = false;
        Get.snackbar('Permission denied', 'Contacts access is required. Enable it in Settings.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load contacts: $e');
    } finally {
      loading.value = false;
    }
  }
}
