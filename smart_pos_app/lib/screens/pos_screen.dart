import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/pos_provider.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filtered = [];

  @override
  void initState() {
    super.initState();
    final prov = Provider.of<ProductProvider>(context, listen: false);
    prov.loadProducts().then((_) {
      setState(() => _filtered = prov.products);
    });
    _searchController.addListener(_onSearch);
  }

  void _onSearch() {
    final q = _searchController.text.trim().toLowerCase();
    final prov = Provider.of<ProductProvider>(context, listen: false);
    if (q.isEmpty) setState(() => _filtered = prov.products);
    else setState(() => _filtered = prov.products.where((p) => p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q)).toList());
  }

  Future<void> _showAddDialog(Product product) async {
    final qtyCtrl = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text('Add ${product.name}'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity'),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Quantity required';
              final val = int.tryParse(v);
              if (val == null || val <= 0) return 'Invalid quantity';
              if (val > product.stockQuantity) return 'Exceeds stock';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final qty = int.parse(qtyCtrl.text);
                Provider.of<PosProvider>(context, listen: false).addProduct(product, qty: qty);
                Navigator.pop(c, true);
              },
              child: const Text('Add')),
        ],
      ),
    );

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PosProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Point of Sale')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search products by name or SKU'),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  // Left: product list
                  Expanded(
                    flex: 2,
                    child: Consumer<ProductProvider>(builder: (context, prov, _) {
                      final list = _searchController.text.trim().isEmpty ? prov.products : _filtered;
                      if (prov.isLoading) return const Center(child: CircularProgressIndicator());
                      if (list.isEmpty) return const Center(child: Text('No products'));
                      return ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          final p = list[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: ListTile(
                              title: Text(p.name),
                              subtitle: Text('SKU: ${p.sku} • Stock: ${p.stockQuantity}'),
                              trailing: Text('\$${p.price.toStringAsFixed(2)}'),
                              onTap: () => _showAddDialog(p),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                  // Right: cart
                  Expanded(
                    flex: 3,
                    child: Consumer2<PosProvider, ProductProvider>(builder: (context, pos, prodProv, _) {
                      return Column(
                        children: [
                          Expanded(
                            child: pos.items.isEmpty
                                ? const Center(child: Text('Cart is empty'))
                                : ListView.builder(
                                    itemCount: pos.items.length,
                                    itemBuilder: (context, idx) {
                                      final item = pos.items[idx];
                                      return Card(
                                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                  child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                                  const SizedBox(height: 6),
                                                  Row(children: [
                                                    IconButton(onPressed: () => pos.decreaseQty(item), icon: const Icon(Icons.remove)),
                                                    Text('${item.quantity}'),
                                                    IconButton(onPressed: () => pos.increaseQty(item), icon: const Icon(Icons.add)),
                                                    const SizedBox(width: 12),
                                                    SizedBox(
                                                      width: 120,
                                                      child: TextField(
                                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                                        decoration: const InputDecoration(labelText: 'Price'),
                                                        controller: TextEditingController(text: item.price.toStringAsFixed(2)),
                                                        onSubmitted: (v) {
                                                          final val = double.tryParse(v) ?? item.price;
                                                          pos.setItemPrice(item, val);
                                                        },
                                                      ),
                                                    ),
                                                  ])
                                                ],
                                              )),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text('\$${item.lineTotal.toStringAsFixed(2)}'),
                                                  IconButton(onPressed: () => pos.removeItem(item), icon: const Icon(Icons.delete, color: Colors.red)),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  const Text('Subtotal'),
                                  Text('\$${pos.subtotal.toStringAsFixed(2)}'),
                                ]),
                                const SizedBox(height: 8),
                                Row(children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(labelText: 'Discount (e.g. 10 or 10%)'),
                                      onChanged: (v) => pos.setDiscountText(v),
                                      keyboardType: TextInputType.text,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      decoration: const InputDecoration(labelText: 'Tax %'),
                                      onChanged: (v) => pos.setTaxText(v),
                                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                    ),
                                  ),
                                ]),
                                const SizedBox(height: 8),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  const Text('Discount'),
                                  Text('-\$${pos.discountValue.toStringAsFixed(2)}'),
                                ]),
                                const SizedBox(height: 4),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  const Text('Tax'),
                                  Text('\$${pos.taxValue.toStringAsFixed(2)}'),
                                ]),
                                const Divider(),
                                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  const Text('Total', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  Text('\$${pos.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ]),
                                const SizedBox(height: 12),
                                if (pos.error != null) Text(pos.error!, style: const TextStyle(color: Colors.red)),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], foregroundColor: Colors.black),
                                        onPressed: pos.items.isEmpty ? null : () => pos.clearCart(),
                                        child: const Text('Clear Cart'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: pos.isProcessing
                                          ? const Center(child: CircularProgressIndicator())
                                          : ElevatedButton(
                                              onPressed: pos.items.isEmpty
                                                  ? null
                                                  : () async {
                                                      final grand = pos.total;
                                                      final saleId = await pos.completeSale(prodProv);
                                                      if (saleId != null) {
                                                        showDialog(
                                                            context: context,
                                                            builder: (c) => AlertDialog(
                                                                  title: const Text('Sale Complete'),
                                                                  content: Text('Total: \$${grand.toStringAsFixed(2)}'),
                                                                  actions: [
                                                                    TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK')),
                                                                    TextButton(
                                                                        onPressed: () {
                                                                          Navigator.pop(c);
                                                                          // reset for new sale
                                                                        },
                                                                        child: const Text('Start New Sale')),
                                                                  ],
                                                                ));
                                                      } else {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pos.error ?? 'Error completing sale')));
                                                      }
                                                    },
                                              child: const Text('Complete Sale'),
                                            ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
