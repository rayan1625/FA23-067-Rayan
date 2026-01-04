import 'package:flutter/material.dart';
import 'products/products_list_screen.dart';
import 'pos_screen.dart';
import 'customers/customers_list_screen.dart';
import 'reports/reports_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart POS')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.point_of_sale),
              label: const Text('New Sale'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PosScreen())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.people),
              label: const Text('Customers'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomersListScreen())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.store),
              label: const Text('Manage Products'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsListScreen())),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.report),
              label: const Text('Reports'),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportsHomeScreen())),
            ),
            const SizedBox(height: 12),
            // Placeholder for future features
            ElevatedButton.icon(
              icon: const Icon(Icons.sync),
              label: const Text('Sync (future)'),
              onPressed: null,
            ),
          ],
        ),
      ),
    );
  }
}
