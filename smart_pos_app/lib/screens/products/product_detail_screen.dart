import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';
import 'add_edit_product_screen.dart';
import 'stock_history_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;
  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Product? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final prov = Provider.of<ProductProvider>(context, listen: false);
    await prov.loadProducts();
    final matches = prov.products.where((x) => x.id == widget.productId).toList();
    _product = matches.isNotEmpty ? matches.first : null;
    setState(() => _isLoading = false);
  }

  Future<void> _showStockDialog(bool isIn) async {
    final qtyCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(isIn ? 'Stock In' : 'Stock Out'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Quantity is required';
                  final val = int.tryParse(v);
                  if (val == null || val <= 0) return 'Quantity must be > 0';
                  return null;
                },
              ),
              TextFormField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Note (optional)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final qty = int.parse(qtyCtrl.text);
              final prov = Provider.of<ProductProvider>(context, listen: false);
              bool ok;
              if (isIn) ok = await prov.stockIn(widget.productId, qty, note: noteCtrl.text.trim());
              else ok = await prov.stockOut(widget.productId, qty, note: noteCtrl.text.trim());
              if (!ok) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${prov.error}')));
                Navigator.pop(c, false);
              } else {
                Navigator.pop(c, true);
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _load();
      final p = Provider.of<ProductProvider>(context, listen: false).products.firstWhere((e) => e.id == widget.productId);
      if (p.stockQuantity < 10) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Warning: Low stock')));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ProductProvider>(context);
    final matches = prov.products.where((x) => x.id == widget.productId).toList();
    final p = matches.isNotEmpty ? matches.first : null;
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (p == null) return Scaffold(body: const Center(child: Text('Product not found')));

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => AddEditProductScreen(product: p)));
              await prov.loadProducts();
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('SKU: ${p.sku}'),
            Text('Category: ${p.category}'),
            Text('Price: \$${p.price.toStringAsFixed(2)}'),
            Text('Cost: \$${p.cost.toStringAsFixed(2)}'),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_downward),
                  label: const Text('Stock In'),
                  onPressed: () => _showStockDialog(true),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.arrow_upward),
                  label: const Text('Stock Out'),
                  onPressed: () => _showStockDialog(false),
                ),
                const SizedBox(width: 12),
                if (p.stockQuantity < 10)
                  const Chip(
                    avatar: Icon(Icons.warning, color: Colors.white, size: 16),
                    backgroundColor: Colors.red,
                    label: Text('Low stock', style: TextStyle(color: Colors.white)),
                  ),
              ],
            ),
            const Divider(height: 24),
            const Text('Stock History', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(child: StockHistoryScreen(productId: widget.productId)),
          ],
        ),
      ),
    );
  }
}
