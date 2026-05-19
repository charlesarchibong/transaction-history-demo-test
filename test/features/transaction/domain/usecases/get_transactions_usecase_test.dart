import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_test/features/transaction/domain/entities/transaction_entity.dart';
import 'package:demo_test/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:demo_test/features/transaction/domain/usecases/get_transactions_usecase.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late GetTransactionsUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionsUseCase(mockRepository);
  });

  final tTransactions = [
    TransactionEntity(
      id: '1',
      amount: 25000,
      customerName: 'John Doe',
      type: TransactionType.deposit,
      date: DateTime(2026, 5, 19),
    ),
  ];

  group('GetTransactionsUseCase', () {
    test('should return list of transactions from repository', () async {
      when(() => mockRepository.getTransactions())
          .thenAnswer((_) async => tTransactions);

      final result = await useCase();

      expect(result, equals(tTransactions));
      verify(() => mockRepository.getTransactions()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate exception from repository', () async {
      when(() => mockRepository.getTransactions())
          .thenThrow(Exception('Network error'));

      expect(() => useCase(), throwsA(isA<Exception>()));
    });
  });
}
