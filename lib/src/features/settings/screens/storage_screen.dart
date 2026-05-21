import 'package:flutter/material.dart';

class StorageScreen extends StatefulWidget {
  const StorageScreen({super.key});

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  bool _autoDownloadWifi = true;
  bool _autoDownloadMobile = false;
  bool _autoDownloadRoaming = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF075E54),
        title: const Text('Storage and data'),
      ),
      body: ListView(
        children: [
          _section('Media auto-download'),
          CheckboxListTile(
            title: const Text('When using Wi-Fi'),
            subtitle: Text('Photos, videos, documents', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            value: _autoDownloadWifi,
            onChanged: (v) => setState(() => _autoDownloadWifi = v ?? true),
            activeColor: const Color(0xFF075E54),
          ),
          CheckboxListTile(
            title: const Text('When using mobile data'),
            subtitle: Text('Photos only', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            value: _autoDownloadMobile,
            onChanged: (v) => setState(() => _autoDownloadMobile = v ?? false),
            activeColor: const Color(0xFF075E54),
          ),
          CheckboxListTile(
            title: const Text('When roaming'),
            subtitle: Text('None', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            value: _autoDownloadRoaming,
            onChanged: (v) => setState(() => _autoDownloadRoaming = v ?? false),
            activeColor: const Color(0xFF075E54),
          ),
          _section('Network usage'),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF075E54).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.network_check, color: Color(0xFF075E54), size: 20),
            ),
            title: const Text('Network usage'),
            subtitle: Text('View data usage', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          _section('Storage'),
          ListTile(
            leading: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF075E54).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.storage, color: Color(0xFF075E54), size: 20),
            ),
            title: const Text('Manage storage'),
            subtitle: Text('Free up space', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: const Color(0xFF075E54),
      )),
    );
  }
}
