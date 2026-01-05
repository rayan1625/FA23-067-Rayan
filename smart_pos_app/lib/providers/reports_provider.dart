import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class ReportsProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  bool loading = false;

  // Sales report state
  Map<String, dynamic>? dailyReport;
  Map<String, dynamic>? monthlyReport;
  Map<String, dynamic>? rangeReport;
  List<Map<String, dynamic>> rangeSales = [];

  // Stock
  List<Map<String, dynamic>> stockItems = [];
  double totalStockValue = 0.0;
  List<Map<String, dynamic>> outOfStock = [];

  // Customers
  List<Map<String, dynamic>> topCustomers = [];
  List<Map<String, dynamic>> customersOutstanding = [];

  Future<void> fetchDailyReport(DateTime date) async {
    loading = true;
    notifyListeners();
    dailyReport = await _db.getDailySalesReport(date);
    loading = false;
    notifyListeners();
  }

  Future<void> fetchMonthlyReport(int year, int month) async {
    loading = true;
    notifyListeners();
    monthlyReport = await _db.getMonthlySalesReport(year, month);
    loading = false;
    notifyListeners();
  }

  Future<void> fetchRangeReport(DateTime from, DateTime to) async {
    loading = true;
    notifyListeners();
    rangeReport = await _db.getSalesForDateRange(from, to);
    rangeSales = await _db.getSalesListForDateRange(from, to);
    loading = false;
    notifyListeners();
  }

  Future<void> fetchStockReports() async {
    loading = true;
    notifyListeners();
    stockItems = await _db.getAllStockItems();
    totalStockValue = await _db.getTotalStockValue();
    outOfStock = await _db.getOutOfStockItems();
    loading = false;
    notifyListeners();
  }

  Future<void> fetchCustomerReports() async {
    loading = true;
    notifyListeners();
    topCustomers = await _db.getTopCustomers();
    customersOutstanding = await _db.getCustomersWithOutstanding();
    loading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchCustomerSummary(int customerId) async {
    return await _db.getCustomerSalesSummary(customerId);
  }

  void clearRange() {
    rangeReport = null;
    rangeSales = [];
    notifyListeners();
  }
}
