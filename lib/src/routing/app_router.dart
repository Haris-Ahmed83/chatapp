import 'package:get/get.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/features/auth/screens/welcome_screen.dart';
import 'package:chato/src/features/auth/screens/phone_input_screen.dart';
import 'package:chato/src/features/auth/screens/otp_screen.dart';
import 'package:chato/src/features/auth/screens/profile_setup_screen.dart';
import 'package:chato/src/features/home/screens/home_screen.dart';
import 'package:chato/src/features/chats/screens/chat_screen.dart';
import 'package:chato/src/features/calls/screens/call_screen.dart';
import 'package:chato/src/features/settings/screens/settings_screen.dart';

class AppRouter {
  static final pages = [
    GetPage(name: AppRoutes.welcome, page: () => const WelcomeScreen()),
    GetPage(name: AppRoutes.phoneInput, page: () => const PhoneInputScreen()),
    GetPage(name: AppRoutes.otpVerification, page: () => const OtpScreen()),
    GetPage(name: AppRoutes.profileSetup, page: () => const ProfileSetupScreen()),
    GetPage(name: AppRoutes.home, page: () => const HomeScreen()),
    GetPage(name: AppRoutes.chat, page: () => const ChatScreen()),
    GetPage(name: AppRoutes.call, page: () => const CallScreen()),
    GetPage(name: AppRoutes.settings, page: () => const SettingsScreen()),
  ];
}
