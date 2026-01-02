import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/customer.dart';
import '../../providers/customer_provider.dart';

class AddEditCustomerScreen extends StatefulWidget {
  final Customer? customer;
  const AddEditCustomerScreen({Key? key, this.customer}) : super(key: key);

  @override
  State<AddEditCustomerScreen> createState() => _AddEditCustomerScreenState();
}

class _AddEditCustomerScreenState extends State<AddEditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _isRegular = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final c = widget.customer;
    if (c != null) {
      _nameCtrl.text = c.name;
      _phoneCtrl.text = c.phone ?? '';
      _addressCtrl.text = c.address ?? '';
      _isRegular = c.isRegular;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final prov = Provider.of<CustomerProvider>(context, listen: false);
    final now = DateTime.now().toIso8601String();
    final customer = Customer(
      id: widget.customer?.id,
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      address: _addressCtrl.text.trim().isEmpty ? null : _addressCtrl.text.trim(),
      isRegular: _isRegular,
      createdAt: widget.customer?.createdAt ?? now,
    );
    bool ok;
    if (widget.customer == null) ok = await prov.addCustomer(customer);
    else ok = await prov.updateCustomer(customer);
    setState(() => _saving = false);
    if (ok) Navigator.pop(context);
    else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${prov.error}')));
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.customer != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Customer' : 'Add Customer')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Name required' : null,
              ),
              TextFormField(controller: _phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
              TextFormField(controller: _addressCtrl, decoration: const InputDecoration(labelText: 'Address')),
              SwitchListTile(title: const Text('Regular customer'), value: _isRegular, onChanged: (v) => setState(() => _isRegular = v)),
              const SizedBox(height: 12),
              _saving ? const CircularProgressIndicator() : ElevatedButton(onPressed: _save, child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}
