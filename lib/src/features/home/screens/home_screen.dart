import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/features/chats/screens/chat_list_screen.dart';
import 'package:chato/src/features/status/screens/status_screen.dart';
import 'package:chato/src/features/calls/screens/calls_screen.dart';
import 'package:chato/src/features/contacts/controllers/contact_controller.dart';
import 'package:chato/src/features/status/controllers/status_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _currentTab = _tabController.index);
      }
    });
    Get.find<ContactController>().loadContacts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'settings') Get.toNamed(AppRoutes.settings);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'settings', child: Text('Settings')),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 15),
          tabs: const [
            Tab(text: 'Chats'),
            Tab(text: 'Status'),
            Tab(text: 'Calls'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ChatListScreen(),
          StatusScreen(),
          CallsScreen(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildFab() {
    if (_currentTab == 0) {
      return FloatingActionButton(
        backgroundColor: const Color(0xFF25D366),
        onPressed: () => Get.toNamed(AppRoutes.contactPicker, arguments: {'purpose': 'chat'}),
        child: const Icon(Icons.chat, color: Colors.white),
      );
    }
    if (_currentTab == 1) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: 'camera_status',
            backgroundColor: Colors.grey[300],
            onPressed: () => Get.find<StatusController>().pickAndUploadStatus(useCamera: true),
            child: const Icon(Icons.camera_alt, color: Color(0xFF075E54)),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'text_status',
            backgroundColor: const Color(0xFF075E54),
            onPressed: () => Get.find<StatusController>().pickAndUploadStatus(),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
