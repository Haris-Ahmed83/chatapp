import 'package:get/get.dart';

class ContactController extends GetxController {
  final contacts = <Map<String, String>>[].obs;
  final loading = false.obs;

  Future<void> loadContacts() async {
    loading.value = true;
    try {
      // Android ke liye flutter_contacts package se real contacts
      // Web ke liye mock data
      contacts.value = [
        {'name': 'Ali Khan', 'phone': '+923001234567'},
        {'name': 'Sara Ahmed', 'phone': '+923112345678'},
        {'name': 'Usman Malik', 'phone': '+923212345678'},
        {'name': 'Fatima Ali', 'phone': '+923312345678'},
      ];
    } finally {
      loading.value = false;
    }
  }
}
