import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/transaction_entity.dart';
import 'transaction_type_x.dart';

class TransactionDetailCard extends StatelessWidget {
  final TransactionEntity transaction;

  const TransactionDetailCard({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = transaction.type;

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 36,
                backgroundColor: type.color.withAlpha(30),
                child: Icon(type.icon, color: type.color, size: 36),
              ),
            ),
            const SizedBox(height: 20),
            _Row(
              key: const Key('detail_amount'),
              label: 'Amount',
              value: NumberFormat.currency(symbol: 'N', decimalDigits: 0)
                  .format(transaction.amount),
              valueStyle: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: type.color,
              ),
            ),
            const Divider(height: 28),
            _Row(
              key: const Key('detail_customer'),
              label: 'Customer',
              value: transaction.customerName,
            ),
            const SizedBox(height: 12),
            _Row(
              key: const Key('detail_type'),
              label: 'Type',
              value: type.label,
            ),
            const SizedBox(height: 12),
            _Row(
              key: const Key('detail_date'),
              label: 'Date',
              value: DateFormat('EEE, MMM d, yyyy – hh:mm a')
                  .format(transaction.date.toLocal()),
            ),
            const SizedBox(height: 12),
            _Row(
              key: const Key('detail_id'),
              label: 'Reference ID',
              value: transaction.id,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _Row({
    required this.label,
    required this.value,
    this.valueStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
