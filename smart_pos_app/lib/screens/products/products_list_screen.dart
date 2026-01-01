import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import 'add_edit_product_screen.dart';
import 'product_detail_screen.dart';

class ProductsListScreen extends StatefulWidget {
  const ProductsListScreen({Key? key}) : super(key: key);

  @override
  State<ProductsListScreen> createState() => _ProductsListScreenState();
}

class _ProductsListScreenState extends State<ProductsListScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by name or SKU',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (v) => Provider.of<ProductProvider>(context, listen: false).searchProducts(v),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              Provider.of<ProductProvider>(context, listen: false).loadProducts();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditProductScreen()));
        },
      ),
      body: Consumer<ProductProvider>(builder: (context, prov, _) {
        if (prov.isLoading) return const Center(child: CircularProgressIndicator());
        if (prov.error != null) return Center(child: Text('Error: ${prov.error}'));
        final products = prov.products;
        if (products.isEmpty) return const Center(child: Text('No products yet.'));
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final p = products[index];
            return Dismissible(
              key: ValueKey(p.id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                return await showDialog<bool>(context: context, builder: (c) {
                  return AlertDialog(
                    title: const Text('Delete product'),
                    content: const Text('Are you sure you want to delete this product?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete')),
                    ],
                  );
                }) ?? false;
              },
              onDismissed: (direction) async {
                if (p.id != null) await prov.deleteProduct(p.id!);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
              },
              child: ListTile(
                title: Text(p.name),
                subtitle: Text('SKU: ${p.sku} • ${p.category}'),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('\$${p.price.toStringAsFixed(2)}'),
                    const SizedBox(height: 4),
                    Text(
                      'Stock: ${p.stockQuantity}',
                      style: TextStyle(color: p.stockQuantity < 10 ? Colors.red : null),
                    ),
                  ],
                ),
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(productId: p.id!)));
                },
              ),
            );
          },
        );
      }),
    );
  }
}
