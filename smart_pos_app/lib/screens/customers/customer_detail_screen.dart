import 'package:flutter/material.dart';
import '../../services/database_helper.dart';
import '../../models/sale.dart';
import '../../models/ledger_entry.dart';

class CustomerDetailScreen extends StatefulWidget {
  final int customerId;
  const CustomerDetailScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  bool _loading = true;
  List<Sale> _sales = [];
  List<LedgerEntry> _ledger = [];
  double _balance = 0.0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final db = DatabaseHelper();
    _sales = await db.getSalesForCustomer(widget.customerId);
    _ledger = await db.getLedgerForCustomer(widget.customerId);
    _balance = await db.getBalanceForCustomer(widget.customerId);
    setState(() => _loading = false);
  }

  Future<void> _showPaymentDialog() async {
    final amtCtrl = TextEditingController();
    final noteCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final res = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Record Payment'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: amtCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Amount'), validator: (v) {if (v==null||v.isEmpty) return 'Amount required'; final val=double.tryParse(v); if (val==null||val<=0) return 'Invalid amount'; return null;}),
              TextFormField(controller: noteCtrl, decoration: const InputDecoration(labelText: 'Note (optional)')),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(c,false), child: const Text('Cancel')), TextButton(onPressed: () async { if(!formKey.currentState!.validate()) return; final db=DatabaseHelper(); final now=DateTime.now().toIso8601String(); await db.insertLedgerEntry(LedgerEntry(customerId: widget.customerId, saleId: null, amount: double.parse(amtCtrl.text), type: 'credit', description: noteCtrl.text.trim(), timestamp: now)); Navigator.pop(c,true);}, child: const Text('Save'))],
      ),
    );
    if (res==true) await _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Customer')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('Outstanding: ', style: TextStyle(fontSize: 16)),
              Text('\$${_balance.toStringAsFixed(2)}', style: TextStyle(fontSize: 16, color: _balance>0?Colors.red:Colors.green)),
              const Spacer(),
              ElevatedButton(onPressed: _showPaymentDialog, child: const Text('Record Payment'))
            ]),
            const SizedBox(height: 12),
            const Text('Purchase History', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: _sales.isEmpty ? const Center(child: Text('No sales')) : ListView.builder(itemCount: _sales.length, itemBuilder: (c,i){final s=_sales[i]; return ListTile(title: Text('Sale #${s.id}'), subtitle: Text('Total: \$${s.total.toStringAsFixed(2)} • ${s.timestamp}'));})),
            const Divider(),
            const Text('Ledger', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: _ledger.isEmpty ? const Center(child: Text('No ledger entries')) : ListView.builder(itemCount: _ledger.length, itemBuilder: (c,i){final e=_ledger[i]; return ListTile(title: Text('${e.type.toUpperCase()}: \$${e.amount.toStringAsFixed(2)}'), subtitle: Text(e.description ?? ''), trailing: Text(e.timestamp));})),
          ],
        ),
      ),
    );
  }
}
