import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import '../database/database_helper.dart';
import 'welcome_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('darkMode') ?? false;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
    setState(() {
      _isDarkMode = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Theme changed to ${value ? 'Dark' : 'Light'}')),
    );
  }

  Future<void> _exportData() async {
    final data = await dbHelper.exportData();
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/dr_assistant_backup_${DateTime.now().millisecondsSinceEpoch}.json');
    await file.writeAsString(jsonEncode(data));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported ${data['patients'].length} patients, ${data['visits'].length} visits'),
        action: SnackBarAction(
          label: 'Open',
          onPressed: () => launchUrl(Uri.file(file.path)),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp() async {
    final url = Uri.parse('https://wa.me/923336262801');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Dark Mode
          Card(
            child: SwitchListTile(
              title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Enable dark theme'),
              value: _isDarkMode,
              onChanged: _toggleDarkMode,
            ),
          ),

          const SizedBox(height: 20),

          // Data Management
          const Text('Data Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.download, color: Colors.green),
              title: const Text('Export Data', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Backup to JSON file'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _exportData,
            ),
          ),

          // Help & Support
          const SizedBox(height: 20),
          const Text('Help & Support', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.message, color: Colors.green),
              title: const Text('WhatsApp Support', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('‪+92 333 626 2801‬'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _openWhatsApp,
            ),
          ),

          // App Info
          const SizedBox(height: 20),
          const Text('App Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.design_services),
              title: const Text('Designed by', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Rayan Shahbaz'),
            ),
          ),

          // Logout
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              onTap: () => _showLogoutDialog(),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const WelcomeScreen(onThemeToggle: null)),
                        (route) => false,
                  );
                },
                child: const Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
            ),
        );
    }
}
