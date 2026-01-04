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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Daily / Monthly Sales'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyMonthlySalesScreen())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.inventory),
              label: const Text('Stock Report'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StockReportScreen())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.person_search),
              label: const Text('Customer Reports'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerReportScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
