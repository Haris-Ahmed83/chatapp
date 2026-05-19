import 'package:get/get.dart';

class CallController extends GetxController {
  final callLog = <Map<String, dynamic>>[].obs;
  final isInCall = false.obs;
  final callDuration = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCallLog();
  }

  void loadCallLog() {
    // TODO: Fetch from Supabase
  }

  void startCall(String userId) {
    // TODO: Initiate LiveKit call
  }

  void endCall() {
    isInCall.value = false;
    callDuration.value = 0;
  }
}
