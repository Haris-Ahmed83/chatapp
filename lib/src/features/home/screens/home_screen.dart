import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chato/src/routing/app_routes.dart';
import 'package:chato/src/features/chats/screens/chat_list_screen.dart';
import 'package:chato/src/features/status/screens/status_screen.dart';
import 'package:chato/src/features/calls/screens/calls_screen.dart';
import 'package:chato/src/features/contacts/controllers/contact_controller.dart';
import 'package:chato/src/features/status/controllers/status_controller.dart';
import 'package:chato/src/features/auth/controllers/auth_controller.dart';
import 'package:chato/src/features/chats/controllers/chat_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;
  bool _isSearching = false;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _currentTab = _tabController.index;
          _isSearching = false;
          _searchController.clear();
        });
      }
    });
    Get.find<ContactController>().loadContacts();
    Get.find<AuthController>().initPresence();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    Get.find<ChatController>().searchQuery.value = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search chats...',
                  hintStyle: TextStyle(color: Colors.white60),
                  border: InputBorder.none,
                ),
              )
            : const Text('WhatsApp'),
        actions: [
          if (_currentTab == 0)
            _isSearching
                ? IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                        Get.find<ChatController>().searchQuery.value = '';
                      });
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.search, color: Colors.white),
                    onPressed: () => setState(() => _isSearching = true),
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
