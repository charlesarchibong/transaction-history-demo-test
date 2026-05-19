import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/transaction_entity.dart';

part 'transaction_model.g.dart';

TransactionType _typeFromJson(String value) => switch (value) {
  'Deposit' => TransactionType.deposit,
  'Withdrawal' => TransactionType.withdrawal,
  'Transfer' => TransactionType.transfer,
  _ => throw FormatException('Unknown transaction type: $value'),
};

String _typeToJson(TransactionType type) => switch (type) {
  TransactionType.deposit => 'Deposit',
  TransactionType.withdrawal => 'Withdrawal',
  TransactionType.transfer => 'Transfer',
};

@JsonSerializable()
class TransactionModel {
  final String id;
  final double amount;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  final TransactionType type;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.amount,
    required this.customerName,
    required this.type,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  TransactionEntity toEntity() => TransactionEntity(
    id: id,
    amount: amount,
    customerName: customerName,
    type: type,
    date: date,
  );

  factory TransactionModel.fromEntity(TransactionEntity entity) =>
      TransactionModel(
        id: entity.id,
        amount: entity.amount,
        customerName: entity.customerName,
        type: entity.type,
        date: entity.date,
      );
}
