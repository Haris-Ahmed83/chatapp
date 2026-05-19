import 'package:get/get.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/features/auth/presentation/screens/welcome_screen.dart';
import 'package:chato/src/features/auth/presentation/screens/phone_input_screen.dart';

import 'package:chato/src/features/auth/presentation/screens/profile_setup_screen.dart';
import 'package:chato/src/features/home/presentation/screens/home_screen.dart';
import 'package:chato/src/features/chats/presentation/screens/chat_screen.dart';
import 'package:chato/src/features/calls/presentation/screens/call_screen.dart';
import 'package:chato/src/features/settings/presentation/screens/settings_screen.dart';

class AppRouter {
  static List<GetPage> get getPages => [
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.phoneInput,
      page: () => const PhoneInputScreen(),
    ),

    GetPage(
      name: AppRoutes.profileSetup,
      page: () => const ProfileSetupScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatScreen(),
    ),
    GetPage(
      name: AppRoutes.call,
      page: () => const CallScreen(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
    ),
  ];
}
