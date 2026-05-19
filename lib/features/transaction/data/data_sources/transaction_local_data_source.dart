import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final AssetBundle assetBundle;

  const TransactionLocalDataSourceImpl({required this.assetBundle});

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final jsonString =
        await assetBundle.loadString('assets/transactions.json');
    final List<dynamic> jsonList =
        json.decode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
