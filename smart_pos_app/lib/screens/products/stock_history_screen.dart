import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/inventory_transaction.dart';
import '../../providers/product_provider.dart';
import 'package:provider/provider.dart';

class StockHistoryScreen extends StatefulWidget {
  final int productId;
  const StockHistoryScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<StockHistoryScreen> createState() => _StockHistoryScreenState();
}

class _StockHistoryScreenState extends State<StockHistoryScreen> {
  bool _loading = true;
  List<InventoryTransaction> _tx = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final prov = Provider.of<ProductProvider>(context, listen: false);
    _tx = await prov.getTransactions(widget.productId);
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_tx.isEmpty) return const Center(child: Text('No history yet'));
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        itemCount: _tx.length,
        itemBuilder: (context, index) {
          final t = _tx[index];
          final dt = DateTime.tryParse(t.timestamp) ?? DateTime.now();
          final formatted = DateFormat.yMd().add_jm().format(dt);
          return ListTile(
            leading: CircleAvatar(child: Text(t.type == 'in' ? '+' : '-')),
            title: Text('${t.quantity} ${t.type.toUpperCase()}'),
            subtitle: Text(t.note ?? ''),
            trailing: Text(formatted),
          );
        },
      ),
    );
  }
}
