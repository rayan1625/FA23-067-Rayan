import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reports_provider.dart';

class StockReportScreen extends StatefulWidget {
  const StockReportScreen({super.key});

  @override
  State<StockReportScreen> createState() => _StockReportScreenState();
}

class _StockReportScreenState extends State<StockReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportsProvider>(context, listen: false).fetchStockReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Report')),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ReportsProvider>(context, listen: false).fetchStockReports(),
        child: Consumer<ReportsProvider>(builder: (context, rp, _) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              Card(
                child: ListTile(
                  title: Text('Total Stock Value: ${rp.totalStockValue.toStringAsFixed(2)}'),
                ),
              ),
              const SizedBox(height: 8),
              const Text('Out of Stock', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              if (rp.outOfStock.isEmpty) const Text('None')
              else
                ...rp.outOfStock.map((p) => Card(
                      child: ListTile(
                        title: Text(p['name'] ?? ''),
                        subtitle: Text('SKU: ${p['sku'] ?? ''}'),
                        trailing: const Text('OUT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    )),
              const SizedBox(height: 12),
              const Text('All Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              ...rp.stockItems.map((p) {
                final qty = (p['stock_quantity'] ?? 0) as int;
                final low = qty <= 5;
                return Card(
                  color: low ? Colors.orange[50] : null,
                  child: ListTile(
                    title: Text('${p['name'] ?? ''}'),
                    subtitle: Text('SKU: ${p['sku'] ?? ''} • Price: ${p['price']?.toStringAsFixed(2) ?? '-'}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Qty: $qty'),
                        Text('Val: ${(p['total_value'] ?? 0).toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                );
              })
            ],
          );
        }),
      ),
    );
  }
}
