import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';
import 'transaction_type_x.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionEntity transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    required this.transaction,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final type = transaction.type;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        key: Key('transaction_item_${transaction.id}'),
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: type.color.withAlpha(30),
          child: Icon(type.icon, color: type.color),
        ),
        title: Text(
          transaction.customerName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${type.label} • ${DateFormat('MMM d, yyyy').format(transaction.date)}',
        ),
        trailing: Text(
          NumberFormat.currency(symbol: 'N', decimalDigits: 0)
              .format(transaction.amount),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: type.color,
          ),
        ),
      ),
    );
  }
}
