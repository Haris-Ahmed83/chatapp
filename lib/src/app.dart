import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/theme/wa_theme.dart';
import 'package:chato/src/routing/app_router.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/routing/app_bindings.dart';

class ChatoApp extends StatelessWidget {
  const ChatoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'WhatsApp do',
      debugShowCheckedModeBanner: false,
      theme: waTheme,
      initialRoute: AppRoutes.welcome,
      getPages: AppRouter.pages,
      initialBinding: AppBindings(),
      defaultTransition: Transition.fadeIn,
    );
  }
}
