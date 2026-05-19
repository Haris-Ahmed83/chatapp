import 'package:get/get.dart';
import 'package:chato/src/features/auth/presentation/controllers/auth_controller.dart';
import 'package:chato/src/features/chats/presentation/controllers/chat_controller.dart';
import 'package:chato/src/features/calls/presentation/controllers/call_controller.dart';
import 'package:chato/src/features/status/presentation/controllers/status_controller.dart';
import 'package:chato/src/features/settings/presentation/controllers/settings_controller.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => CallController());
    Get.lazyPut(() => StatusController());
    Get.lazyPut(() => SettingsController());
  }
}
