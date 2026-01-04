import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();
  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

class BackupService {
  static final BackupService _instance = BackupService._internal();
  factory BackupService() => _instance;
  BackupService._internal();

  Future<String> _getDbPath() async {
    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'smart_pos.db');
    return path;
  }

  Future<File> backupToLocal() async {
    final status = await Permission.storage.request();
    if (!status.isGranted) throw Exception('Storage permission denied');
    final dbPath = await _getDbPath();
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) throw Exception('DB not found');
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final dest = File(p.join(dir.path, 'smart_pos_backup_$timestamp.db'));
    return await dbFile.copy(dest.path);
  }

  Future<drive.File> backupToDrive(GoogleSignInAccount account) async {
    final auth = await account.authentication;
    final headers = {'Authorization': 'Bearer ${auth.accessToken}'};
    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    final dbPath = await _getDbPath();
    final dbFile = File(dbPath);
    if (!await dbFile.exists()) throw Exception('DB not found');
    final media = drive.Media(dbFile.openRead(), await dbFile.length());
    final file = drive.File();
    file.name = 'smart_pos_backup_${DateTime.now().toIso8601String()}.db';
    // upload to appDataFolder to avoid clutter
    final created = await driveApi.files.create(file, uploadMedia: media, supportsAllDrives: false, fields: 'id,name', spaces: 'appDataFolder');
    return created;
  }

  Future<List<drive.File>> listDriveBackups(GoogleSignInAccount account) async {
    final auth = await account.authentication;
    final headers = {'Authorization': 'Bearer ${auth.accessToken}'};
    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    final res = await driveApi.files.list(spaces: 'appDataFolder', q: "name contains 'smart_pos_backup_'");
    return res.files ?? [];
  }

  Future<File> downloadDriveBackup(GoogleSignInAccount account, String fileId) async {
    final auth = await account.authentication;
    final headers = {'Authorization': 'Bearer ${auth.accessToken}'};
    final client = GoogleAuthClient(headers);
    final driveApi = drive.DriveApi(client);
    final data = await driveApi.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    final bytes = <int>[];
    final completer = Completer<List<int>>();
    data.stream.listen((chunk) => bytes.addAll(chunk), onDone: () => completer.complete(bytes), onError: (e) => completer.completeError(e));
    final fileBytes = await completer.future;
    final dir = await getApplicationDocumentsDirectory();
    final dest = File(p.join(dir.path, 'smart_pos_restore_${DateTime.now().toIso8601String()}.db'));
    await dest.writeAsBytes(fileBytes, flush: true);
    return dest;
  }

  Future<void> restoreFromLocal() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result == null) return;
    final picked = File(result.files.single.path!);
    final dbPath = await _getDbPath();
    // close DB
    try {
      final db = await openDatabase(dbPath);
      await db.close();
    } catch (_) {}
    await picked.copy(dbPath);
  }

  Future<void> restoreFromFile(File file) async {
    final dbPath = await _getDbPath();
    try {
      final db = await openDatabase(dbPath);
      await db.close();
    } catch (_) {}
    await file.copy(dbPath);
  }
}
