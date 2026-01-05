import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/reports_provider.dart';

class CustomerReportScreen extends StatefulWidget {
  const CustomerReportScreen({super.key});

  @override
  State<CustomerReportScreen> createState() => _CustomerReportScreenState();
}

class _CustomerReportScreenState extends State<CustomerReportScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportsProvider>(context, listen: false).fetchCustomerReports();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Reports')),
      body: RefreshIndicator(
        onRefresh: () => Provider.of<ReportsProvider>(context, listen: false).fetchCustomerReports(),
        child: Consumer<ReportsProvider>(builder: (context, rp, _) {
          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              const Text('Top Customers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...rp.topCustomers.map((c) => Card(
                    child: ListTile(
                      title: Text(c['name'] ?? ''),
                      subtitle: Text('Total purchases: ${c['total_purchase']?.toStringAsFixed(2) ?? '0.00'} • Bills: ${c['bills'] ?? 0}'),
                      onTap: () async {
                        final summary = await rp.fetchCustomerSummary(c['id']);
                        if (!mounted) return;
                        showDialog(context: context, builder: (ctx) => AlertDialog(
                          title: Text('Summary - ${c['name']}'),
                          content: Text('Total: ${summary['total'].toStringAsFixed(2)}\nBills: ${summary['bills']}\nLast: ${summary['last_sale'] ?? 'N/A'}'),
                          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
                        ));
                      },
                    ),
                  )),
              const SizedBox(height: 12),
              const Text('Customers with Outstanding Balance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (rp.customersOutstanding.isEmpty) const Text('None')
              else
                ...rp.customersOutstanding.map((c) => Card(
                      child: ListTile(
                        title: Text(c['name'] ?? ''),
                        trailing: Text(c['balance']?.toStringAsFixed(2) ?? '0.00', style: const TextStyle(color: Colors.red)),
                      ),
                    )),
            ],
          );
        }),
      ),
    );
  }
}
