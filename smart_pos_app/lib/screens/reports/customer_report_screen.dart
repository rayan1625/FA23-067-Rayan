import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/reports_provider.dart';

class CustomerReportScreen extends StatefulWidget {
  const CustomerReportScreen({super.key});

  @override
  State<CustomerReportScreen> createState() => _CustomerReportScreenState();
}

class _CustomerReportScreenState extends State<CustomerReportScreen> {
  List<Map<String, dynamic>> _top = [];
  List<Map<String, dynamic>> _owing = [];
  bool _loading = true;

  Future<void> _load() async {
    setState(() => _loading = true);
    final provider = Provider.of<ReportsProvider>(context, listen: false);
    final top = await provider.fetchTopCustomers();
    final owing = await provider.fetchCustomersWithOutstanding();
    setState(() {
      _top = top;
      _owing = owing;
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
      appBar: AppBar(title: const Text('Customer Reports')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Top Customers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._top.map((c) => Card(
                          child: ListTile(
                            title: Text(c['name'] ?? ''),
                            trailing: Text(NumberFormat.simpleCurrency().format((c['total'] ?? 0.0))),
                          ),
                        )),
                    const SizedBox(height: 16),
                    const Text('Customers with Outstanding Balance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._owing.map((c) => Card(
                          child: ListTile(
                            title: Text(c['name'] ?? ''),
                            trailing: Text(NumberFormat.simpleCurrency().format((c['balance'] ?? 0.0))),
                          ),
                        )),
                  ],
                ),
              ),
      ),
    );
  }
}
