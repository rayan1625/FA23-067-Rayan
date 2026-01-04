import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/database_helper.dart';

class ReportsProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  bool isLoading = false;

  Future<Map<String, dynamic>> fetchDailySales(DateTime day) async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getDailySales(day);
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<Map<String, dynamic>> fetchMonthlySales(int year, int month) async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getMonthlySales(year, month);
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<Map<String, dynamic>> fetchSalesInRange(DateTime start, DateTime end) async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getSalesInRange(start, end);
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<List<Map<String, dynamic>>> fetchStockList() async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getStockList();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<double> fetchTotalStockValue() async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getTotalStockValue();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<List<Map<String, dynamic>>> fetchOutOfStockItems() async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getOutOfStockItems();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<List<Map<String, dynamic>>> fetchTopCustomers({int limit = 10}) async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getTopCustomers(limit: limit);
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<List<Map<String, dynamic>>> fetchCustomersWithOutstanding() async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getCustomersWithOutstanding();
    isLoading = false;
    notifyListeners();
    return res;
  }

  Future<Map<String, dynamic>> fetchCustomerSummary(int customerId) async {
    isLoading = true;
    notifyListeners();
    final res = await _db.getCustomerSalesSummary(customerId);
    isLoading = false;
    notifyListeners();
    return res;
  }
}
