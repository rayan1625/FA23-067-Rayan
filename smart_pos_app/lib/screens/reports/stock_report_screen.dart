import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/reports_provider.dart';

class StockReportScreen extends StatefulWidget {
  const StockReportScreen({super.key});

  @override
  State<StockReportScreen> createState() => _StockReportScreenState();
}

class _StockReportScreenState extends State<StockReportScreen> {
  List<Map<String, dynamic>> _items = [];
  double _totalValue = 0.0;
  bool _loading = true;

  Future<void> _load() async {
    setState(() => _loading = true);
    final provider = Provider.of<ReportsProvider>(context, listen: false);
    final items = await provider.fetchStockList();
    final value = await provider.fetchTotalStockValue();
    setState(() {
      _items = items;
      _totalValue = value;
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Report')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _items.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Card(
                      child: ListTile(
                        title: Text('Total Stock Value: ${NumberFormat.simpleCurrency().format(_totalValue)}'),
                        subtitle: Text('Out of stock: ${_items.where((e) => (e['stock_quantity'] as int) <= 0).length}'),
                      ),
                    );
                  }
                  final item = _items[index - 1];
                  final qty = item['stock_quantity'] as int? ?? 0;
                  final low = qty <= 5;
                  return Card(
                    color: low ? Colors.orange[50] : null,
                    child: ListTile(
                      title: Text(item['name'] ?? ''),
                      subtitle: Text('SKU: ${item['sku'] ?? ''} • Price: ${NumberFormat.simpleCurrency().format((item['price'] ?? 0.0))}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Qty: $qty', style: TextStyle(color: low ? Colors.orange[800] : null)),
                          if (qty <= 0) Text('OUT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
