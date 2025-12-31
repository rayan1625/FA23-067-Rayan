import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../providers/product_provider.dart';

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  const AddEditProductScreen({Key? key, this.product}) : super(key: key);

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _skuController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _costController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      _skuController.text = p.sku;
      _nameController.text = p.name;
      _priceController.text = p.price.toString();
      _costController.text = p.cost.toString();
      _categoryController.text = p.category;
      _stockController.text = p.stockQuantity.toString();
    }
  }

  @override
  void dispose() {
    _skuController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final provider = Provider.of<ProductProvider>(context, listen: false);
    final sku = _skuController.text.trim();
    final name = _nameController.text.trim();
    final price = double.parse(_priceController.text);
    final cost = double.parse(_costController.text);
    final category = _categoryController.text.trim();
    final stock = int.parse(_stockController.text);

    final product = Product(
      id: widget.product?.id,
      sku: sku,
      name: name,
      price: price,
      cost: cost,
      category: category,
      stockQuantity: stock,
    );

    bool ok;
    if (widget.product == null) {
      ok = await provider.addProduct(product);
    } else {
      ok = await provider.updateProduct(product);
    }

    setState(() => _isSaving = false);
    if (ok) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${provider.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _skuController,
                  decoration: const InputDecoration(labelText: 'SKU'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'SKU is required' : null,
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Name is required' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Price is required';
                    final val = double.tryParse(v);
                    if (val == null || val <= 0) return 'Price must be > 0';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _costController,
                  decoration: const InputDecoration(labelText: 'Cost'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Cost is required';
                    final val = double.tryParse(v);
                    if (val == null || val <= 0) return 'Cost must be > 0';
                    return null;
                  },
                ),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Category is required' : null,
                ),
                TextFormField(
                  controller: _stockController,
                  decoration: const InputDecoration(labelText: 'Initial Stock'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Stock is required';
                    final val = int.tryParse(v);
                    if (val == null || val < 0) return 'Stock must be >= 0';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isSaving
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _save,
                        child: const Text('Save'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
