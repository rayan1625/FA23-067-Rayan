import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';
import '../models/inventory_transaction.dart';
import '../models/sale.dart';
import '../models/sale_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'smart_pos.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sku TEXT UNIQUE,
        name TEXT,
        price REAL,
        cost REAL,
        category TEXT,
        stock_quantity INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE inventory_transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_id INTEGER,
        type TEXT,
        quantity INTEGER,
        note TEXT,
        timestamp TEXT
      )
    ''');

    // Sales tables
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_date TEXT,
        subtotal REAL,
        discount REAL,
        tax REAL,
        total REAL,
        timestamp TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sale_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sale_id INTEGER,
        product_id INTEGER,
        quantity INTEGER,
        price_at_sale REAL,
        line_total REAL
      )
    ''');
  }

  // Product CRUD
  Future<int> insertProduct(Product p) async {
    final db = await database;
    return await db.insert('products', p.toMap(), conflictAlgorithm: ConflictAlgorithm.abort);
  }

  // Sales
  Future<int> insertSale(Sale sale) async {
    final db = await database;
    return await db.insert('sales', sale.toMap());
  }

  Future<int> insertSaleItem(SaleItem item) async {
    final db = await database;
    return await db.insert('sale_items', item.toMap());
  }

  /// Save a sale and its items atomically. This will check stock availability, update product stock,
  /// insert sale and items, and create inventory transactions for each item (type 'out').
  Future<int> saveSaleWithItems(Sale sale, List<SaleItem> items) async {
    final db = await database;
    return await db.transaction<int>((txn) async {
      final saleId = await txn.insert('sales', sale.toMap());
      for (final item in items) {
        final itemMap = item.toMap();
        itemMap['sale_id'] = saleId;
        // Check current stock
        final prodRows = await txn.query('products', where: 'id = ?', whereArgs: [item.productId]);
        if (prodRows.isEmpty) throw Exception('Product not found');
        final currentStock = prodRows.first['stock_quantity'] as int;
        if (currentStock < item.quantity) throw Exception('Insufficient stock for product id ${item.productId}');
        // Insert sale item
        await txn.insert('sale_items', itemMap);
        // Update stock
        final newStock = currentStock - item.quantity;
        await txn.update('products', {'stock_quantity': newStock}, where: 'id = ?', whereArgs: [item.productId]);
        // Insert inventory transaction
        await txn.insert('inventory_transactions', {
          'product_id': item.productId,
          'type': 'out',
          'quantity': item.quantity,
          'note': 'Sold (sale id: $saleId)',
          'timestamp': sale.timestamp,
        });
      }
      return saleId;
    });
  }

  Future<List<Map<String, dynamic>>> getSales() async {
    final db = await database;
    return await db.query('sales', orderBy: 'timestamp DESC');
  }

  Future<List<Map<String, dynamic>>> getSaleItemsForSale(int saleId) async {
    final db = await database;
    return await db.query('sale_items', where: 'sale_id = ?', whereArgs: [saleId]);
  }

  Future<int> updateProduct(Product p) async {
    final db = await database;
    return await db.update('products', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final maps = await db.query('products', orderBy: 'name COLLATE NOCASE');
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final db = await database;
    final maps = await db.query(
      'products',
      where: 'name LIKE ? OR sku LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return maps.map((m) => Product.fromMap(m)).toList();
  }

  Future<Product?> getProductById(int id) async {
    final db = await database;
    final maps = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Product.fromMap(maps.first);
    return null;
  }

  // Transactions
  Future<int> insertTransaction(InventoryTransaction t) async {
    final db = await database;
    return await db.insert('inventory_transactions', t.toMap());
  }

  Future<List<InventoryTransaction>> getTransactionsForProduct(int productId) async {
    final db = await database;
    final maps = await db.query(
      'inventory_transactions',
      where: 'product_id = ?',
      whereArgs: [productId],
      orderBy: 'timestamp DESC',
    );
    return maps.map((m) => InventoryTransaction.fromMap(m)).toList();
  }

  Future<int> updateStockQuantity(int productId, int newQuantity) async {
    final db = await database;
    return await db.update(
      'products',
      {'stock_quantity': newQuantity},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  // For cleanup in tests
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
