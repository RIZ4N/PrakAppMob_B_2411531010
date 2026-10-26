import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'transaction_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<TransactionItem> _transactions = [];
  String _filter = 'Semua';
  final List<String> _filters = ['Semua', 'Pemasukan', 'Pengeluaran'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final transactions = await DatabaseHelper.getTransactions(Session.currentUser!.id);
    if (!mounted) return;
    setState(() {
      _transactions = transactions;
    });
  }

  List<TransactionItem> get _filteredTransactions {
    if (_filter == 'Pemasukan') {
      return _transactions.where((t) => t.isIncome).toList();
    }
    if (_filter == 'Pengeluaran') {
      return _transactions.where((t) => !t.isIncome).toList();
    }
    return _transactions;
  }

  @override
  Widget build(BuildContext context) {
    final transactions = _filteredTransactions;

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Transaksi')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _filters.map((filter) {
                return ChoiceChip(
                  label: Text(filter),
                  selected: _filter == filter,
                  selectedColor: kPrimaryColor,
                  labelStyle: TextStyle(
                    color: _filter == filter ? Colors.white : Colors.black87,
                  ),
                  showCheckmark: false,
                  onSelected: (_) => setState(() => _filter = filter),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: transactions.isEmpty
                ? const Center(
                    child: Text('Belum ada transaksi', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.separated(
                    itemCount: transactions.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) => TransactionTile(
                      transaction: transactions[index],
                      onChanged: _loadData,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
