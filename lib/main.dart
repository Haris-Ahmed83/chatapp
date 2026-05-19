import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:chato/src/config/app_config.dart';
import 'package:chato/src/shared/wrappers/screen_util_wrapper.dart';
import 'package:chato/src/shared/notify.dart';
import 'package:chato/src/routing/app_bindings.dart';
import 'package:chato/src/routing/app_router.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/theme/wa_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
    await AppConfig.init();
  } catch (_) {}

  runApp(const ChatoApp());
}

class ChatoApp extends StatefulWidget {
  const ChatoApp({super.key});

  @override
  State<ChatoApp> createState() => _ChatoAppState();
}

class _ChatoAppState extends State<ChatoApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifyReady());
  }

  void _notifyReady() {
    notifyFlutterReady();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilWrapper(
      child: GetMaterialApp(
        title: 'Chato',
        debugShowCheckedModeBanner: false,
        theme: buildWaLightTheme(),
        initialRoute: AppRoutes.welcome,
        getPages: AppRouter.getPages,
        initialBinding: AppBindings(),
        defaultTransition: Transition.fadeIn,
      ),
    );
  }
}
