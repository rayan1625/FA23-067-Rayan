import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../models/ledger_entry.dart';
import '../services/database_helper.dart';

class CustomerProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();
  List<Customer> _customers = [];
  bool _isLoading = false;
  String? _error;

  List<Customer> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCustomers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _customers = await _db.getAllCustomers();
      // ensure Walk-in exists (id not enforced)
      final walkins = _customers.where((c) => c.name.toLowerCase() == 'walk-in').toList();
      if (walkins.isEmpty) {
        final now = DateTime.now().toIso8601String();
        await _db.insertCustomer(Customer(name: 'Walk-in', phone: null, address: null, isRegular: false, createdAt: now));
        _customers = await _db.getAllCustomers();
      }
    } catch (e) {
      _error = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> addCustomer(Customer c) async {
    try {
      await _db.insertCustomer(c);
      await loadCustomers();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateCustomer(Customer c) async {
    try {
      await _db.updateCustomer(c);
      await loadCustomers();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteCustomer(int id) async {
    try {
      await _db.deleteCustomer(id);
      await loadCustomers();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<List<LedgerEntry>> getLedger(int customerId) async {
    try {
      return await _db.getLedgerForCustomer(customerId);
    } catch (e) {
      _error = e.toString();
      return [];
    }
  }

  Future<double> getBalance(int customerId) async {
    try {
      return await _db.getBalanceForCustomer(customerId);
    } catch (e) {
      _error = e.toString();
      return 0.0;
    }
  }
}
