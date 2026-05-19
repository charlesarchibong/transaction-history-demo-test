import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_test/features/transaction/data/data_sources/transaction_local_data_source.dart';
import 'package:demo_test/features/transaction/data/models/transaction_model.dart';
import 'package:demo_test/features/transaction/data/repositories/transaction_repository_impl.dart';
import 'package:demo_test/features/transaction/domain/entities/transaction_entity.dart';

class MockTransactionLocalDataSource extends Mock
    implements TransactionLocalDataSource {}

void main() {
  late TransactionRepositoryImpl repository;
  late MockTransactionLocalDataSource mockDataSource;

  final tModels = [
    TransactionModel(
      id: '1',
      amount: 25000,
      customerName: 'John Doe',
      type: TransactionType.deposit,
      date: DateTime.utc(2026, 5, 19),
    ),
    TransactionModel(
      id: '2',
      amount: 12000,
      customerName: 'Alice Smith',
      type: TransactionType.withdrawal,
      date: DateTime.utc(2026, 5, 18),
    ),
  ];

  setUp(() {
    mockDataSource = MockTransactionLocalDataSource();
    repository = TransactionRepositoryImpl(localDataSource: mockDataSource);
  });

  group('TransactionRepositoryImpl', () {
    group('getTransactions', () {
      test('should return list of entities from data source', () async {
        when(() => mockDataSource.getTransactions())
            .thenAnswer((_) async => tModels);

        final result = await repository.getTransactions();

        expect(result.length, 2);
        expect(result[0], isA<TransactionEntity>());
        expect(result[0].id, '1');
        expect(result[1].id, '2');
        verify(() => mockDataSource.getTransactions()).called(1);
      });
    });

    group('getTransactionById', () {
      test('should return entity for valid id', () async {
        when(() => mockDataSource.getTransactions())
            .thenAnswer((_) async => tModels);

        final result = await repository.getTransactionById('1');

        expect(result.id, '1');
        expect(result.customerName, 'John Doe');
      });

      test('should throw StateError for unknown id', () async {
        when(() => mockDataSource.getTransactions())
            .thenAnswer((_) async => tModels);

        expect(
          () => repository.getTransactionById('999'),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
