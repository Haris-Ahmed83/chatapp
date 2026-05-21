import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as fc;

class ContactController extends GetxController {
  final contacts = <Map<String, String>>[].obs;
  final loading = false.obs;

  Future<void> loadContacts() async {
    loading.value = true;
    try {
      final granted = await fc.FlutterContacts.requestPermission(readonly: true);
      if (granted) {
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
        Get.snackbar('Permission denied', 'Contacts permission is required to show contacts');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load contacts: $e');
    } finally {
      loading.value = false;
    }
  }
}
