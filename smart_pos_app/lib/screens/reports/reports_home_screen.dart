import 'package:flutter/material.dart';
import 'daily_monthly_sales_screen.dart';
import 'stock_report_screen.dart';
import 'customer_report_screen.dart';

class ReportsHomeScreen extends StatelessWidget {
  const ReportsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Sales Reports'),
                subtitle: const Text('Daily, monthly and custom range'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyMonthlySalesScreen())),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text('Stock Report'),
                subtitle: const Text('Current stock, low and out of stock items'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockReportScreen())),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.people_outline),
                title: const Text('Customer Reports'),
                subtitle: const Text('Top customers and outstanding balances'),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerReportScreen())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
