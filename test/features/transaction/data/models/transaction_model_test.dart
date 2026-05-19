import 'package:flutter_test/flutter_test.dart';
import 'package:demo_test/features/transaction/data/models/transaction_model.dart';
import 'package:demo_test/features/transaction/domain/entities/transaction_entity.dart';

void main() {
  final tModel = TransactionModel(
    id: '1',
    amount: 25000,
    customerName: 'John Doe',
    type: TransactionType.deposit,
    date: DateTime.utc(2026, 5, 19, 10, 0, 0),
  );

  final tJson = <String, dynamic>{
    'id': '1',
    'amount': 25000.0,
    'customer_name': 'John Doe',
    'type': 'Deposit',
    'date': '2026-05-19T10:00:00.000Z',
  };

  group('TransactionModel', () {
    group('fromJson', () {
      test('should parse a valid JSON map correctly', () {
        final model = TransactionModel.fromJson(tJson);

        expect(model.id, '1');
        expect(model.amount, 25000.0);
        expect(model.customerName, 'John Doe');
        expect(model.type, TransactionType.deposit);
      });

      test('should throw FormatException for unknown transaction type', () {
        final badJson = Map<String, dynamic>.from(tJson)
          ..['type'] = 'Unknown';
        expect(() => TransactionModel.fromJson(badJson),
            throwsA(isA<FormatException>()));
      });
    });

    group('toJson', () {
      test('should serialize model back to JSON map', () {
        final json = tModel.toJson();

        expect(json['id'], '1');
        expect(json['amount'], 25000.0);
        expect(json['customer_name'], 'John Doe');
        expect(json['type'], 'Deposit');
      });
    });

    group('toEntity', () {
      test('should convert model to TransactionEntity', () {
        final entity = tModel.toEntity();

        expect(entity.id, tModel.id);
        expect(entity.amount, tModel.amount);
        expect(entity.customerName, tModel.customerName);
        expect(entity.type, tModel.type);
        expect(entity.date, tModel.date);
      });
    });

    group('fromEntity', () {
      test('should create model from TransactionEntity', () {
        final entity = tModel.toEntity();
        final model = TransactionModel.fromEntity(entity);

        expect(model.id, entity.id);
        expect(model.amount, entity.amount);
        expect(model.customerName, entity.customerName);
      });
    });
  });
}
