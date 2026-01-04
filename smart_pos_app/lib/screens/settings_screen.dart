import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/backup_service.dart';
import '../services/sync_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _working = false;
  final _backup = BackupService();

  Future<void> _localBackup() async {
    setState(() => _working = true);
    try {
      final file = await _backup.backupToLocal();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Backup saved: ${file.path}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup failed')));
    } finally {
      setState(() => _working = false);
    }
  }

  Future<void> _driveBackup() async {
    setState(() => _working = true);
    try {
      final account = await GoogleSignIn(scopes: ['https://www.googleapis.com/auth/drive.appdata','https://www.googleapis.com/auth/drive.file']).signIn();
      if (account == null) return;
      final file = await _backup.backupToDrive(account);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploaded: ${file.name}')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Drive backup failed')));
    } finally {
      setState(() => _working = false);
    }
  }

  Future<void> _manualSync() async {
    setState(() => _working = true);
    try {
      await SyncService().syncAll();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync complete')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sync failed')));
    } finally {
      setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final syncStatus = SyncService().isSyncing ? 'Syncing...' : 'Idle';
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(title: const Text('Sync Status'), subtitle: Text(syncStatus)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.sync),
              label: const Text('Manual Sync'),
              onPressed: _working ? null : _manualSync,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Backup to Local'),
              onPressed: _working ? null : _localBackup,
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Backup to Google Drive'),
              onPressed: _working ? null : _driveBackup,
            ),
          ],
        ),
      ),
    );
  }
}
