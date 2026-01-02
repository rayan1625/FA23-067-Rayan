import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/customer_provider.dart';
import 'add_edit_customer_screen.dart';
import 'customer_detail_screen.dart';

class CustomersListScreen extends StatefulWidget {
  const CustomersListScreen({Key? key}) : super(key: key);

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  final _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CustomerProvider>(context, listen: false).loadCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditCustomerScreen()));
          await Provider.of<CustomerProvider>(context, listen: false).loadCustomers();
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(controller: _search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search')),
          ),
          Expanded(child: Consumer<CustomerProvider>(builder: (context, prov, _) {
            if (prov.isLoading) return const Center(child: CircularProgressIndicator());
            final list = _search.text.trim().isEmpty ? prov.customers : prov.customers.where((c) => c.name.toLowerCase().contains(_search.text.toLowerCase()) || (c.phone ?? '').contains(_search.text)).toList();
            if (list.isEmpty) return const Center(child: Text('No customers'));
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, idx) {
                final c = list[idx];
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.phone ?? ''),
                  trailing: c.isRegular ? const Icon(Icons.person) : const SizedBox.shrink(),
                  onTap: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerDetailScreen(customerId: c.id!)));
                    await Provider.of<CustomerProvider>(context, listen: false).loadCustomers();
                  },
                );
              },
            );
          }))
        ],
      ),
    );
  }
}
