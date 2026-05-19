import 'package:flutter/material.dart';
import '../../domain/entities/transaction_entity.dart';

extension TransactionTypeX on TransactionType {
  Color get color => switch (this) {
    TransactionType.deposit => Colors.green,
    TransactionType.withdrawal => Colors.red,
    TransactionType.transfer => Colors.blue,
  };

  IconData get icon => switch (this) {
    TransactionType.deposit => Icons.arrow_downward,
    TransactionType.withdrawal => Icons.arrow_upward,
    TransactionType.transfer => Icons.swap_horiz,
  };

  String get label => switch (this) {
    TransactionType.deposit => 'Deposit',
    TransactionType.withdrawal => 'Withdrawal',
    TransactionType.transfer => 'Transfer',
  };
}
