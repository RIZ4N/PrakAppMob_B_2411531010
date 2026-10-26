import 'package:flutter/material.dart';
import 'models.dart';
import 'transaction_detail_screen.dart';

class TransactionTile extends StatelessWidget {
  final TransactionItem transaction;
  final VoidCallback? onChanged;

  const TransactionTile({super.key, required this.transaction, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: categoryColor(transaction.category),
        child: Icon(categoryIcon(transaction.category), color: Colors.white),
      ),
      title: Text(transaction.title),
      subtitle: Text(transaction.date),
      trailing: Text(
        transaction.amountText,
        style: TextStyle(
          color: transaction.isIncome ? Colors.green : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () async {
        final deleted = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => TransactionDetailScreen(
              id: transaction.id!,
              title: transaction.title,
              amount: transaction.amountText,
              category: transaction.category,
              date: transaction.date,
            ),
          ),
        );
        if (deleted == true) onChanged?.call();
      },
    );
  }
}
