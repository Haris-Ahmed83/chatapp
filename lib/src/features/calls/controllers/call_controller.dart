import 'package:get/get.dart';

class CallController extends GetxController {
  final isInCall = false.obs;
  final callDuration = '00:00'.obs;

  void startCall(String userId) {
    isInCall.value = true;
  }

  void endCall() {
    isInCall.value = false;
  }
}
