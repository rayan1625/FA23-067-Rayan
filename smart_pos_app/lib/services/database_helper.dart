import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';
import '../models/inventory_transaction.dart';
import '../models/sale.dart';
import '../models/sale_item.dart';
import '../models/customer.dart';
import '../models/ledger_entry.dart';

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

    return await openDatabase(path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // add customer_id to sales table if missing
      try {
        await db.execute('ALTER TABLE sales ADD COLUMN customer_id INTEGER');
      } catch (_) {}

      // create customers table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS customers (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT,
          address TEXT,
          is_regular INTEGER,
          created_at TEXT
        )
      ''');

      // create ledger_entries table
      await db.execute('''
        CREATE TABLE IF NOT EXISTS ledger_entries (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          customer_id INTEGER,
          sale_id INTEGER,
          amount REAL,
          type TEXT,
          description TEXT,
          timestamp TEXT
        )
      ''');
    }
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

    // Sales tables (include customer_id)
    await db.execute('''
      CREATE TABLE sales (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER,
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
    // customers and ledger (initial creation)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS customers (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        address TEXT,
        is_regular INTEGER,
        created_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS ledger_entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        customer_id INTEGER,
        sale_id INTEGER,
        amount REAL,
        type TEXT,
        description TEXT,
        timestamp TEXT
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

  Future<List<Sale>> getSalesForCustomer(int customerId) async {
    final db = await database;
    final maps = await db.query('sales', where: 'customer_id = ?', whereArgs: [customerId], orderBy: 'timestamp DESC');
    return maps.map((m) => Sale.fromMap(m)).toList();
  }

  Future<List<Map<String, dynamic>>> getSaleItemsForSale(int saleId) async {
    final db = await database;
    return await db.query('sale_items', where: 'sale_id = ?', whereArgs: [saleId]);
  }

  // Customers
  Future<int> insertCustomer(Customer c) async {
    final db = await database;
    return await db.insert('customers', c.toMap());
  }

  Future<int> updateCustomer(Customer c) async {
    final db = await database;
    return await db.update('customers', c.toMap(), where: 'id = ?', whereArgs: [c.id]);
  }

  Future<int> deleteCustomer(int id) async {
    final db = await database;
    return await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final maps = await db.query('customers', orderBy: 'name COLLATE NOCASE');
    return maps.map((m) => Customer.fromMap(m)).toList();
  }

  Future<List<Customer>> searchCustomers(String q) async {
    final db = await database;
    final maps = await db.query('customers', where: 'name LIKE ? OR phone LIKE ?', whereArgs: ['%$q%', '%$q%']);
    return maps.map((m) => Customer.fromMap(m)).toList();
  }

  Future<Customer?> getCustomerById(int id) async {
    final db = await database;
    final maps = await db.query('customers', where: 'id = ?', whereArgs: [id]);
    if (maps.isNotEmpty) return Customer.fromMap(maps.first);
    return null;
  }

  // Ledger
  Future<int> insertLedgerEntry(LedgerEntry e) async {
    final db = await database;
    return await db.insert('ledger_entries', e.toMap());
  }

  Future<List<LedgerEntry>> getLedgerForCustomer(int customerId) async {
    final db = await database;
    final maps = await db.query('ledger_entries', where: 'customer_id = ?', whereArgs: [customerId], orderBy: 'timestamp DESC');
    return maps.map((m) => LedgerEntry.fromMap(m)).toList();
  }

  Future<double> getBalanceForCustomer(int customerId) async {
    final db = await database;
    final res = await db.rawQuery('SELECT SUM(CASE WHEN type = "debit" THEN amount ELSE -amount END) as bal FROM ledger_entries WHERE customer_id = ?', [customerId]);
    final val = res.first['bal'];
    if (val == null) return 0.0;
    return (val as num).toDouble();
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

  // Reports: Sales
  Future<Map<String, dynamic>> getDailySalesReport(DateTime date) async {
    final db = await database;
    final dateStr = date.toIso8601String().split('T').first; // YYYY-MM-DD

    final totalRes = await db.rawQuery('SELECT IFNULL(SUM(total),0) as total_sales, COUNT(*) as bills FROM sales WHERE date(sale_date) = ?', [dateStr]);
    final profitRes = await db.rawQuery('''
      SELECT IFNULL(SUM((si.price_at_sale - p.cost) * si.quantity),0) as profit
      FROM sale_items si
      JOIN sales s ON si.sale_id = s.id
      JOIN products p ON si.product_id = p.id
      WHERE date(s.sale_date) = ?
    ''', [dateStr]);

    return {
      'date': dateStr,
      'total_sales': (totalRes.first['total_sales'] as num).toDouble(),
      'bills': totalRes.first['bills'] ?? 0,
      'profit': (profitRes.first['profit'] as num).toDouble(),
    };
  }

  Future<Map<String, dynamic>> getMonthlySalesReport(int year, int month) async {
    final db = await database;
    final monthStr = '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}'; // YYYY-MM

    final totalRes = await db.rawQuery('SELECT IFNULL(SUM(total),0) as total_sales, COUNT(*) as bills FROM sales WHERE strftime("%Y-%m", sale_date) = ?', [monthStr]);
    final profitRes = await db.rawQuery('''
      SELECT IFNULL(SUM((si.price_at_sale - p.cost) * si.quantity),0) as profit
      FROM sale_items si
      JOIN sales s ON si.sale_id = s.id
      JOIN products p ON si.product_id = p.id
      WHERE strftime("%Y-%m", s.sale_date) = ?
    ''', [monthStr]);

    return {
      'month': monthStr,
      'total_sales': (totalRes.first['total_sales'] as num).toDouble(),
      'bills': totalRes.first['bills'] ?? 0,
      'profit': (profitRes.first['profit'] as num).toDouble(),
    };
  }

  Future<Map<String, dynamic>> getSalesForDateRange(DateTime from, DateTime to) async {
    final db = await database;
    final fromStr = from.toIso8601String().split('T').first;
    final toStr = to.toIso8601String().split('T').first;

    final totalRes = await db.rawQuery('SELECT IFNULL(SUM(total),0) as total_sales, COUNT(*) as bills FROM sales WHERE date(sale_date) BETWEEN ? AND ?', [fromStr, toStr]);
    final profitRes = await db.rawQuery('''
      SELECT IFNULL(SUM((si.price_at_sale - p.cost) * si.quantity),0) as profit
      FROM sale_items si
      JOIN sales s ON si.sale_id = s.id
      JOIN products p ON si.product_id = p.id
      WHERE date(s.sale_date) BETWEEN ? AND ?
    ''', [fromStr, toStr]);

    return {
      'from': fromStr,
      'to': toStr,
      'total_sales': (totalRes.first['total_sales'] as num).toDouble(),
      'bills': totalRes.first['bills'] ?? 0,
      'profit': (profitRes.first['profit'] as num).toDouble(),
    };
  }

  Future<List<Map<String, dynamic>>> getSalesListForDateRange(DateTime from, DateTime to) async {
    final db = await database;
    final fromStr = from.toIso8601String();
    final toStr = to.toIso8601String();
    return await db.rawQuery('SELECT * FROM sales WHERE sale_date BETWEEN ? AND ? ORDER BY timestamp DESC', [fromStr, toStr]);
  }

  // Stock reports
  Future<List<Map<String, dynamic>>> getAllStockItems() async {
    final db = await database;
    return await db.rawQuery('SELECT *, (IFNULL(price,0) * IFNULL(stock_quantity,0)) as total_value FROM products ORDER BY name COLLATE NOCASE');
  }

  Future<double> getTotalStockValue() async {
    final db = await database;
    final res = await db.rawQuery('SELECT IFNULL(SUM(IFNULL(price,0) * IFNULL(stock_quantity,0)),0) as total_value FROM products');
    return (res.first['total_value'] as num).toDouble();
  }

  Future<List<Map<String, dynamic>>> getOutOfStockItems() async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM products WHERE IFNULL(stock_quantity,0) <= 0 ORDER BY name COLLATE NOCASE');
  }

  // Customer reports
  Future<List<Map<String, dynamic>>> getTopCustomers({int limit = 10}) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT c.id, c.name, IFNULL(SUM(s.total),0) as total_purchase, COUNT(s.id) as bills
      FROM customers c
      LEFT JOIN sales s ON s.customer_id = c.id
      GROUP BY c.id
      ORDER BY total_purchase DESC
      LIMIT ?
    ''', [limit]);
  }

  Future<List<Map<String, dynamic>>> getCustomersWithOutstanding() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT c.id, c.name, IFNULL(SUM(CASE WHEN le.type = "debit" THEN le.amount ELSE -le.amount END),0) as balance
      FROM customers c
      LEFT JOIN ledger_entries le ON c.id = le.customer_id
      GROUP BY c.id
      HAVING balance > 0
      ORDER BY balance DESC
    ''');
  }

  Future<Map<String, dynamic>> getCustomerSalesSummary(int customerId) async {
    final db = await database;
    final res = await db.rawQuery('SELECT IFNULL(SUM(total),0) as total, COUNT(*) as bills, IFNULL(MAX(sale_date),"") as last_sale FROM sales WHERE customer_id = ?', [customerId]);
    return {
      'total': (res.first['total'] as num).toDouble(),
      'bills': res.first['bills'] ?? 0,
      'last_sale': res.first['last_sale'] ?? '',
    };
  }

  // For cleanup in tests
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
