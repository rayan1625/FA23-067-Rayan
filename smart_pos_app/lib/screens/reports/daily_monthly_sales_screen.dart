import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/reports_provider.dart';

class DailyMonthlySalesScreen extends StatefulWidget {
  const DailyMonthlySalesScreen({super.key});

  @override
  State<DailyMonthlySalesScreen> createState() => _DailyMonthlySalesScreenState();
}

class _DailyMonthlySalesScreenState extends State<DailyMonthlySalesScreen> {
  DateTime selectedFrom = DateTime.now();
  DateTime selectedTo = DateTime.now();

  @override
  void initState() {
    super.initState();
    final rp = Provider.of<ReportsProvider>(context, listen: false);
    rp.fetchDailyReport(DateTime.now());
    final now = DateTime.now();
    rp.fetchMonthlyReport(now.year, now.month);
  }

  Future<void> _pickRange() async {
    final from = await showDatePicker(context: context, initialDate: selectedFrom, firstDate: DateTime(2000), lastDate: DateTime.now());
    if (from == null) return;
    final to = await showDatePicker(context: context, initialDate: selectedTo, firstDate: from, lastDate: DateTime.now());
    if (to == null) return;
    setState(() {
      selectedFrom = from;
      selectedTo = to;
    });
    await Provider.of<ReportsProvider>(context, listen: false).fetchRangeReport(from, to);
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat.yMMMd();
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Reports')),
      body: RefreshIndicator(
        onRefresh: () async {
          final rp = Provider.of<ReportsProvider>(context, listen: false);
          rp.fetchDailyReport(DateTime.now());
          final now = DateTime.now();
          rp.fetchMonthlyReport(now.year, now.month);
          await rp.fetchCustomerReports();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(12),
          child: Consumer<ReportsProvider>(builder: (context, rp, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Today', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: Text('Sales: ${rp.dailyReport != null ? rp.dailyReport!['total_sales'].toStringAsFixed(2) : '-'}'),
                    subtitle: Text('Bills: ${rp.dailyReport != null ? rp.dailyReport!['bills'] : '-'}\nProfit: ${rp.dailyReport != null ? rp.dailyReport!['profit'].toStringAsFixed(2) : '-'}'),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('This Month', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    title: Text('Sales: ${rp.monthlyReport != null ? rp.monthlyReport!['total_sales'].toStringAsFixed(2) : '-'}'),
                    subtitle: Text('Bills: ${rp.monthlyReport != null ? rp.monthlyReport!['bills'] : '-'}\nProfit: ${rp.monthlyReport != null ? rp.monthlyReport!['profit'].toStringAsFixed(2) : '-'}'),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: const Text('Choose Range'),
                      onPressed: _pickRange,
                    ),
                    const SizedBox(width: 12),
                    if (rp.rangeReport != null)
                      Text('Range: ${fmt.format(DateTime.parse(rp.rangeReport!['from']))} - ${fmt.format(DateTime.parse(rp.rangeReport!['to']))}'),
                  ],
                ),
                const SizedBox(height: 12),
                if (rp.rangeReport != null) ...[
                  Card(
                    child: ListTile(
                      title: Text('Total: ${rp.rangeReport!['total_sales'].toStringAsFixed(2)}'),
                      subtitle: Text('Bills: ${rp.rangeReport!['bills']}\nProfit: ${rp.rangeReport!['profit'].toStringAsFixed(2)}'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Sales in Range', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ListView.builder(
                    itemCount: rp.rangeSales.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (c, i) {
                      final s = rp.rangeSales[i];
                      final date = DateTime.tryParse(s['sale_date'] ?? s['timestamp'] ?? '') ?? DateTime.now();
                      return Card(
                        child: ListTile(
                          title: Text('Bill #${s['id']} - ${s['total']?.toStringAsFixed(2) ?? '-'}'),
                          subtitle: Text('Date: ${fmt.format(date)}'),
                        ),
                      );
                    },
                  )
                ]
              ],
            );
          }),
        ),
      ),
    );
  }
}
