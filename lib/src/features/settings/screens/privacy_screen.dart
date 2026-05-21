import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  String _lastSeen = 'Everyone';
  String _profilePhoto = 'Everyone';
  String _about = 'Everyone';
  String _status = 'My contacts';
  bool _readReceipts = true;

  final _options = ['Everyone', 'My contacts', 'Nobody'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Privacy'),
      ),
      body: ListView(
        children: [
          _section('Who can see my personal info'),
          _choiceTile('Last seen & online', _lastSeen, (v) => setState(() => _lastSeen = v)),
          _choiceTile('Profile photo', _profilePhoto, (v) => setState(() => _profilePhoto = v)),
          _choiceTile('About', _about, (v) => setState(() => _about = v)),
          _choiceTile('Status', _status, (v) => setState(() => _status = v)),
          const Divider(),
          SwitchListTile(
            title: const Text('Read receipts'),
            subtitle: const Text('If turned off, you won\'t send read receipts'),
            value: _readReceipts,
            onChanged: (v) => setState(() => _readReceipts = v),
            activeColor: const Color(0xFF075E54),
          ),
          const Divider(),
          _section('Groups'),
          ListTile(
            title: const Text('Groups'),
            subtitle: Text('Everyone', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _showPicker('Groups', _lastSeen, (v) {}),
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
