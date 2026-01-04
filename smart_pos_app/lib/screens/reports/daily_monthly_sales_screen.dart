import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/reports_provider.dart';

class DailyMonthlySalesScreen extends StatefulWidget {
  const DailyMonthlySalesScreen({super.key});

  @override
  State<DailyMonthlySalesScreen> createState() => _DailyMonthlySalesScreenState();
}

class _DailyMonthlySalesScreenState extends State<DailyMonthlySalesScreen> {
  DateTimeRange? _range;
  Map<String, dynamic>? _rangeResult;

  Future<void> _refreshDailyMonthly() async {
    final provider = Provider.of<ReportsProvider>(context, listen: false);
    // today's
    await provider.fetchDailySales(DateTime.now());
    await provider.fetchMonthlySales(DateTime.now().year, DateTime.now().month);
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => _range = picked);
      final provider = Provider.of<ReportsProvider>(context, listen: false);
      final res = await provider.fetchSalesInRange(picked.start, picked.end);
      setState(() => _rangeResult = res);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportsProvider>(context);
    final todayFuture = provider.fetchDailySales(DateTime.now());
    final monthFuture = provider.fetchMonthlySales(DateTime.now().year, DateTime.now().month);
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Reports')),
      body: RefreshIndicator(
        onRefresh: _refreshDailyMonthly,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              FutureBuilder<Map<String, dynamic>>(
                future: todayFuture,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) return const CircularProgressIndicator();
                  final data = snap.data ?? {'total': 0.0, 'bills': 0, 'profit': 0.0};
                  return Card(
                    child: ListTile(
                      title: Text('Total: ${NumberFormat.simpleCurrency().format(data['total'])}'),
                      subtitle: Text('Bills: ${data['bills']} • Profit: ${NumberFormat.simpleCurrency().format(data['profit'])}'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text('This Month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              FutureBuilder<Map<String, dynamic>>(
                future: monthFuture,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) return const CircularProgressIndicator();
                  final data = snap.data ?? {'total': 0.0, 'bills': 0, 'profit': 0.0, 'previous_total': 0.0};
                  final prev = data['previous_total'] as double;
                  final curr = data['total'] as double;
                  final diff = curr - prev;
                  final pct = prev == 0 ? (curr == 0 ? 0.0 : 100.0) : (diff / prev * 100.0);
                  return Card(
                    child: ListTile(
                      title: Text('Total: ${NumberFormat.simpleCurrency().format(curr)}'),
                      subtitle: Text('Bills: ${data['bills']} • Profit: ${NumberFormat.simpleCurrency().format(data['profit'])}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${pct.toStringAsFixed(1)}%'),
                          Text('vs prev month', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text('Custom Range', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.date_range),
                    label: const Text('Pick Range'),
                    onPressed: _pickRange,
                  ),
                  const SizedBox(width: 12),
                  if (_range != null) Text('${DateFormat.yMd().format(_range!.start)} - ${DateFormat.yMd().format(_range!.end)}'),
                ],
              ),
              const SizedBox(height: 8),
              if (_rangeResult != null)
                Card(
                  child: ListTile(
                    title: Text('Total: ${NumberFormat.simpleCurrency().format(_rangeResult!['total'])}'),
                    subtitle: Text('Bills: ${_rangeResult!['bills']} • Profit: ${NumberFormat.simpleCurrency().format(_rangeResult!['profit'])}'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
