import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../models/sale_item.dart';
import '../services/database_helper.dart';
import 'product_provider.dart';
import 'customer_provider.dart';
import '../models/ledger_entry.dart';

class CartItem {
  final Product product;
  int quantity;
  double price; // runtime editable

  CartItem({required this.product, required this.quantity, required this.price});

  double get lineTotal => (price * quantity);
}

class PosProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  final List<CartItem> _items = [];
  bool _isProcessing = false;
  String? _error;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isProcessing => _isProcessing;
  String? get error => _error;

  void clearError() {
    _error = null;
  }

  double get subtotal => _items.fold(0.0, (s, i) => s + i.lineTotal);

  String _discountText = '';
  String _taxText = '';

  String get discountText => _discountText;
  String get taxText => _taxText;

  void setDiscountText(String v) {
    _discountText = v;
    notifyListeners();
  }

  void setTaxText(String v) {
    _taxText = v;
    notifyListeners();
  }

  double _parseDiscountValue() {
    final t = _discountText.trim();
    if (t.isEmpty) return 0.0;
    if (t.endsWith('%')) {
      final numPart = t.substring(0, t.length - 1);
      final pct = double.tryParse(numPart) ?? 0.0;
      return (pct / 100.0) * subtotal;
    }
    final amt = double.tryParse(t) ?? 0.0;
    return amt;
  }

  double _parseTaxValue(double base) {
    final t = _taxText.trim();
    if (t.isEmpty) return 0.0;
    final pct = t.endsWith('%') ? double.tryParse(t.replaceAll('%', '')) ?? 0.0 : double.tryParse(t) ?? 0.0;
    return (pct / 100.0) * base;
  }

  double get discountValue => double.parse(_parseDiscountValue().toStringAsFixed(2));

  double get taxValue {
    final base = subtotal - discountValue;
    return double.parse(_parseTaxValue(base).toStringAsFixed(2));
  }

  double get total => double.parse((subtotal - discountValue + taxValue).toStringAsFixed(2));

  void addProduct(Product p, {int qty = 1}) {
    final existing = _items.where((i) => i.product.id == p.id).toList();
    if (existing.isNotEmpty) {
      final item = existing.first;
      if (item.quantity + qty > p.stockQuantity) {
        _error = 'Cannot add more than available stock';
        notifyListeners();
        return;
      }
      item.quantity += qty;
    } else {
      if (qty > p.stockQuantity) {
        _error = 'Cannot add more than available stock';
        notifyListeners();
        return;
      }
      _items.add(CartItem(product: p, quantity: qty, price: p.price));
    }
    _error = null;
    notifyListeners();
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void increaseQty(CartItem item) {
    if (item.quantity + 1 > item.product.stockQuantity) {
      _error = 'Not enough stock';
      notifyListeners();
      return;
    }
    item.quantity += 1;
    _error = null;
    notifyListeners();
  }

  void decreaseQty(CartItem item) {
    if (item.quantity > 1) item.quantity -= 1;
    notifyListeners();
  }

  void setItemPrice(CartItem item, double price) {
    item.price = price;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _discountText = '';
    _taxText = '';
    _error = null;
    notifyListeners();
  }

  /// Completes sale: validates stock, writes sale and items to DB (atomically), updates product stock,
  /// logs inventory_transactions via DB helper. Refreshes productProvider afterwards.
  Future<int?> completeSale(ProductProvider productProvider, {int? customerId, CustomerProvider? customerProvider}) async {
    if (_items.isEmpty) {
      _error = 'Cart is empty';
      notifyListeners();
      return null;
    }
    // Validate stock availability
    for (final item in _items) {
      final product = productProvider.products.firstWhere((p) => p.id == item.product.id);
      if (item.quantity > product.stockQuantity) {
        _error = 'Not enough stock for ${product.name}';
        notifyListeners();
        return null;
      }
    }

    _isProcessing = true;
    _error = null;
    notifyListeners();

    try {
      final now = DateTime.now();
      final sale = Sale(
        customerId: customerId,
        saleDate: DateTime(now.year, now.month, now.day).toIso8601String(),
        subtotal: subtotal,
        discount: discountValue,
        tax: taxValue,
        total: total,
        timestamp: now.toIso8601String(),
      );
      final itemsToSave = _items.map((ci) {
        return SaleItem(
          saleId: 0,
          productId: ci.product.id!,
          quantity: ci.quantity,
          priceAtSale: ci.price,
          lineTotal: double.parse((ci.lineTotal).toStringAsFixed(2)),
        );
      }).toList();

      final saleId = await _db.saveSaleWithItems(sale, itemsToSave);

      // If a regular customer was selected, add a ledger debit entry
      if (customerId != null && customerProvider != null) {
        // try to find customer and ensure regular
        final matches = customerProvider.customers.where((c) => c.id == customerId).toList();
        if (matches.isNotEmpty && matches.first.isRegular) {
          final ledger = LedgerEntry(
            customerId: customerId,
            saleId: saleId,
            amount: total,
            type: 'debit',
            description: 'Sale #$saleId',
            timestamp: now.toIso8601String(),
          );
          await _db.insertLedgerEntry(ledger);
        }
      }

      // Refresh products and customers
      await productProvider.loadProducts();
      if (customerProvider != null) await customerProvider.loadCustomers();

      clearCart();
      _isProcessing = false;
      notifyListeners();
      return saleId;
    } catch (e) {
      _isProcessing = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }
}
