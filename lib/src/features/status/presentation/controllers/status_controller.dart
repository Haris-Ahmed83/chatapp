import 'package:get/get.dart';

class StatusController extends GetxController {
  final statusList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadStatus();
  }

  void loadStatus() {
    // TODO: Fetch from Supabase
  }

  void postStatus(String imageUrl, String caption) {
    // TODO: Post status
  }
}
