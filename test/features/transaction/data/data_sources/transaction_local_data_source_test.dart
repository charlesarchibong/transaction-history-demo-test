import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_test/features/transaction/data/data_sources/transaction_local_data_source.dart';
import 'package:demo_test/features/transaction/domain/entities/transaction_entity.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

void main() {
  late TransactionLocalDataSourceImpl dataSource;
  late MockAssetBundle mockBundle;

  const tJsonString = '''[
    {
      "id": "1",
      "amount": 25000,
      "customer_name": "John Doe",
      "type": "Deposit",
      "date": "2026-05-19T10:00:00Z"
    },
    {
      "id": "2",
      "amount": 12000,
      "customer_name": "Alice Smith",
      "type": "Withdrawal",
      "date": "2026-05-18T09:30:00Z"
    }
  ]''';

  setUp(() {
    mockBundle = MockAssetBundle();
    dataSource = TransactionLocalDataSourceImpl(assetBundle: mockBundle);
  });

  group('TransactionLocalDataSourceImpl', () {
    test('should return list of TransactionModels from asset', () async {
      when(() => mockBundle.loadString('assets/transactions.json'))
          .thenAnswer((_) async => tJsonString);

      final result = await dataSource.getTransactions();

      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].customerName, 'John Doe');
      expect(result[0].type, TransactionType.deposit);
      expect(result[1].id, '2');
      expect(result[1].type, TransactionType.withdrawal);
    });

    test('should throw when asset cannot be loaded', () async {
      when(() => mockBundle.loadString('assets/transactions.json'))
          .thenThrow(Exception('Unable to load asset'));

      expect(
        () => dataSource.getTransactions(),
        throwsA(isA<Exception>()),
      );
    });

    test('should throw FormatException for malformed JSON', () async {
      when(() => mockBundle.loadString('assets/transactions.json'))
          .thenAnswer((_) async => 'not valid json');

      expect(
        () => dataSource.getTransactions(),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
