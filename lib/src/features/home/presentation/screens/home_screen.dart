import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/features/chats/presentation/screens/chat_list_screen.dart';
import 'package:chato/src/features/status/presentation/screens/status_screen.dart';
import 'package:chato/src/features/calls/presentation/screens/calls_screen.dart';
import 'package:chato/src/features/settings/presentation/screens/settings_screen.dart';
import 'package:chato/src/features/auth/presentation/controllers/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chato'),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'logout') {
                  Get.find<AuthController>().signOut();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'settings', child: Text('Settings')),
                const PopupMenuItem(value: 'logout', child: Text('Log out')),
              ],
            ),
          ],
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Color(0xFFB0B0B0),
            tabs: [
              Tab(icon: Icon(Icons.chat_bubble_outline), text: 'Chats'),
              Tab(icon: Icon(Icons.circle_outlined), text: 'Status'),
              Tab(icon: Icon(Icons.phone_outlined), text: 'Calls'),
              Tab(icon: Icon(Icons.settings_outlined), text: 'Settings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ChatListScreen(),
            StatusScreen(),
            CallsScreen(),
            SettingsScreen(),
          ],
        ),
      ),
    );
  }
}
