import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;

class ContactController extends GetxController {
  final contacts = <Map<String, String>>[].obs;
  final loading = false.obs;
  final permissionGranted = false.obs;

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
        contacts.value = raw.map((c) {
          final phone = c.phones.isNotEmpty ? c.phones.first.number : '';
          return {
            'name': c.displayName.isNotEmpty ? c.displayName : 'Unknown',
            'phone': phone,
          };
        }).where((c) => c['phone']!.isNotEmpty).toList();
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
