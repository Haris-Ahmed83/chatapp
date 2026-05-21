import 'package:get/get.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';
import 'package:chato/src/features/chats/controllers/chat_controller.dart';
import 'package:chato/src/features/calls/controllers/call_controller.dart';
import 'package:chato/src/features/contacts/controllers/contact_controller.dart';
import 'package:chato/src/features/status/controllers/status_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<CallController>(() => CallController());
    Get.lazyPut<ContactController>(() => ContactController());
    Get.lazyPut<StatusController>(() => StatusController());
  }
}
