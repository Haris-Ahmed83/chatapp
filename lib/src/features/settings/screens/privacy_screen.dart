import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String _lastSeen = 'Everyone';
  String _profilePhoto = 'Everyone';
  String _about = 'Everyone';
  bool _readReceipts = true;
  bool _loaded = false;

  final _options = ['Everyone', 'My contacts', 'Nobody'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _lastSeen = prefs.getString('privacy_last_seen') ?? 'Everyone';
      _profilePhoto = prefs.getString('privacy_photo') ?? 'Everyone';
      _about = prefs.getString('privacy_about') ?? 'Everyone';
      _readReceipts = prefs.getBool('privacy_read_receipts') ?? true;
      _loaded = true;
    });
  }

  Future<void> _save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Privacy'),
      ),
      body: ListView(
        children: [
          _section('Who can see my personal info'),
          _choiceTile('Last seen & online', _lastSeen, (v) {
            setState(() => _lastSeen = v);
            _save('privacy_last_seen', v);
            Get.snackbar('Last seen', 'Changed to $v', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
          }),
          _choiceTile('Profile photo', _profilePhoto, (v) {
            setState(() => _profilePhoto = v);
            _save('privacy_photo', v);
            Get.snackbar('Profile photo', 'Changed to $v', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
          }),
          _choiceTile('About', _about, (v) {
            setState(() => _about = v);
            _save('privacy_about', v);
            Get.snackbar('About', 'Changed to $v', snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
          }),
          const Divider(),
          SwitchListTile(
            title: const Text('Read receipts'),
            subtitle: const Text('If turned off, you won\'t send read receipts'),
            value: _readReceipts,
            onChanged: (v) async {
              setState(() => _readReceipts = v);
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('privacy_read_receipts', v);
              Get.snackbar('Read receipts', v ? 'Enabled' : 'Disabled',
                snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 1));
            },
            activeColor: const Color(0xFF075E54),
          ),
          const Divider(),
          _section('Groups'),
          ListTile(
            title: const Text('Add me to groups'),
            subtitle: Text('Everyone', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _showPicker('Add me to groups', 'Everyone', (v) {}),
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF075E54))),
    );
  }

  Widget _choiceTile(String title, String value, ValueChanged<String> onChanged) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () => _showPicker(title, value, onChanged),
    );
  }

  void _showPicker(String title, String current, ValueChanged<String> onChanged) {
    Get.dialog(SimpleDialog(
      title: Text(title),
      children: _options.map((o) => SimpleDialogOption(
        onPressed: () { onChanged(o); Get.back(); },
        child: Row(
          children: [
            Icon(o == current ? Icons.radio_button_checked : Icons.radio_button_off,
              color: const Color(0xFF075E54), size: 20),
            const SizedBox(width: 12),
            Text(o),
          ],
        ),
      )).toList(),
    ));
  }
}
