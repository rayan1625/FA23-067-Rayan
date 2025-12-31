import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/inventory_transaction.dart';
import '../services/database_helper.dart';
import 'package:intl/intl.dart';

class ProductProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _db.getAllProducts();
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> searchProducts(String query) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (query.trim().isEmpty) {
        _products = await _db.getAllProducts();
      } else {
        _products = await _db.searchProducts(query);
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addProduct(Product p) async {
    try {
      final id = await _db.insertProduct(p);
      if (p.stockQuantity > 0) {
        final timestamp = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
        await _db.insertTransaction(InventoryTransaction(
          productId: id,
          type: 'in',
          quantity: p.stockQuantity,
          note: 'Initial stock',
          timestamp: timestamp,
        ));
      }
      _products.add(p.copyWith(id: id));
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(Product p) async {
    try {
      await _db.updateProduct(p);
      final idx = _products.indexWhere((x) => x.id == p.id);
      if (idx != -1) {
        _products[idx] = p;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      await _db.deleteProduct(id);
      _products.removeWhere((x) => x.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<List<InventoryTransaction>> getTransactions(int productId) async {
    try {
      return await _db.getTransactionsForProduct(productId);
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  Future<bool> stockIn(int productId, int qty, {String? note}) async {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      final newQty = product.stockQuantity + qty;
      await _db.updateStockQuantity(productId, newQty);
      final timestamp = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
      await _db.insertTransaction(InventoryTransaction(
        productId: productId,
        type: 'in',
        quantity: qty,
        note: note,
        timestamp: timestamp,
      ));
      // update local list
      final idx = _products.indexWhere((p) => p.id == productId);
      if (idx != -1) {
        _products[idx] = product.copyWith(stockQuantity: newQty);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> stockOut(int productId, int qty, {String? note}) async {
    try {
      final product = _products.firstWhere((p) => p.id == productId);
      final newQty = product.stockQuantity - qty;
      if (newQty < 0) throw Exception('Not enough stock');
      await _db.updateStockQuantity(productId, newQty);
      final timestamp = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
      await _db.insertTransaction(InventoryTransaction(
        productId: productId,
        type: 'out',
        quantity: qty,
        note: note,
        timestamp: timestamp,
      ));
      final idx = _products.indexWhere((p) => p.id == productId);
      if (idx != -1) {
        _products[idx] = product.copyWith(stockQuantity: newQty);
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }
}
