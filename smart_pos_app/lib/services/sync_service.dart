import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/database_helper.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final DatabaseHelper _db = DatabaseHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription<ConnectivityResult>? _connSub;
  bool isSyncing = false;

  void start() {
    _connSub ??= Connectivity().onConnectivityChanged.listen((event) async {
      if (event != ConnectivityResult.none) {
        await syncAll();
      }
    });
    // Also try initial sync if signed in
    if (FirebaseAuth.instance.currentUser != null) syncAll();
  }

  void stop() {
    _connSub?.cancel();
    _connSub = null;
  }

  Future<void> syncAll() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (isSyncing) return;
    isSyncing = true;
    try {
      final uid = user.uid;
      // Upload local data
      await _uploadCollection('products', uid);
      await _uploadCollection('inventory_transactions', uid);
      await _uploadCollection('customers', uid);
      await _uploadCollection('ledger_entries', uid);
      await _uploadCollection('sales', uid);
      await _uploadCollection('sale_items', uid);

      // Download remote changes
      await _downloadCollection('products', uid);
      await _downloadCollection('inventory_transactions', uid);
      await _downloadCollection('customers', uid);
      await _downloadCollection('ledger_entries', uid);
      await _downloadCollection('sales', uid);
      await _downloadCollection('sale_items', uid);
    } catch (e) {
      // ignore errors for now
    } finally {
      isSyncing = false;
    }
  }

  Future<void> _uploadCollection(String table, String uid) async {
    final colRef = _firestore.collection('users').doc(uid).collection(table);
    List<Map<String, dynamic>> rows = [];
    switch (table) {
      case 'products':
        rows = await _db.getAllProductsRaw();
        break;
      case 'inventory_transactions':
        rows = await _db.getAllInventoryTransactionsRaw();
        break;
      case 'customers':
        rows = await _db.getAllCustomersRaw();
        break;
      case 'ledger_entries':
        rows = await _db.getAllLedgerEntriesRaw();
        break;
      case 'sales':
        rows = await _db.getAllSalesRaw();
        break;
      case 'sale_items':
        rows = await _db.getAllSaleItemsRaw();
        break;
      default:
        rows = [];
    }

    for (final row in rows) {
      try {
        final id = row['id']?.toString() ?? '';
        final localTimestamp = row['sync_timestamp'] ?? row['timestamp'] ?? DateTime.now().toIso8601String();
        final docRef = colRef.doc(id);
        final doc = await docRef.get();
        final remoteLast = doc.exists ? (doc.data()?['last_updated'] as String?) : null;
        // Conflict handling: last write wins, but for 'sales' prefer local
        bool shouldUpload = false;
        if (!doc.exists) {
          shouldUpload = true;
        } else if (table == 'sales') {
          shouldUpload = true; // prefer local for sales
        } else if (remoteLast == null) {
          shouldUpload = true;
        } else {
          try {
            final remoteTime = DateTime.parse(remoteLast);
            final localTime = DateTime.parse(localTimestamp);
            if (localTime.isAfter(remoteTime)) shouldUpload = true;
          } catch (_) {
            shouldUpload = true;
          }
        }
        if (shouldUpload) {
          final data = Map<String, dynamic>.from(row);
          data['last_updated'] = DateTime.now().toIso8601String();
          // remove unsupported types
          data.removeWhere((k, v) => v is DateTime);
          await docRef.set(data);
          await _db.updateSyncStatus(table, row['id'] as int, 'synced', DateTime.now().toIso8601String());
        }
      } catch (_) {}
    }
  }

  Future<void> _downloadCollection(String table, String uid) async {
    final colRef = _firestore.collection('users').doc(uid).collection(table);
    final snapshot = await colRef.get();
    final db = await _db.database;
    for (final doc in snapshot.docs) {
      try {
        final data = doc.data();
        final id = int.tryParse(doc.id) ?? data['id'];
        final remoteLast = data['last_updated'] as String? ?? '';
        // get local sync_timestamp
        final localRows = await db.query(table, where: 'id = ?', whereArgs: [id]);
        if (localRows.isEmpty) {
          // insert remote as new local row
          final insertMap = Map<String, Object?>.from(data);
          insertMap.remove('last_updated');
          // Ensure id preserved when inserting
          insertMap['id'] = id;
          await db.insert(table, insertMap, conflictAlgorithm: ConflictAlgorithm.replace);
          await _db.updateSyncStatus(table, id, 'synced', remoteLast);
        } else {
          final local = localRows.first;
          final localSync = local['sync_timestamp'] as String? ?? '';
          bool shouldApplyRemote = false;
          if (table == 'sales') {
            // prefer local for sales
            shouldApplyRemote = false;
          } else {
            if (remoteLast.isNotEmpty && localSync.isNotEmpty) {
              try {
                final r = DateTime.parse(remoteLast);
                final l = DateTime.parse(localSync);
                if (r.isAfter(l)) shouldApplyRemote = true;
              } catch (_) {
                shouldApplyRemote = true;
              }
            } else if (remoteLast.isNotEmpty && localSync.isEmpty) {
              shouldApplyRemote = true;
            }
          }
          if (shouldApplyRemote) {
            final updateMap = Map<String, Object?>.from(data);
            updateMap.remove('last_updated');
            await db.update(table, updateMap, where: 'id = ?', whereArgs: [id]);
            await _db.updateSyncStatus(table, id, 'synced', remoteLast);
          }
        }
      } catch (_) {}
    }
  }
}
