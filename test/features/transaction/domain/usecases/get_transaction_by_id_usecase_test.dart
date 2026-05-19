import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_test/features/transaction/domain/entities/transaction_entity.dart';
import 'package:demo_test/features/transaction/domain/repositories/transaction_repository.dart';
import 'package:demo_test/features/transaction/domain/usecases/get_transaction_by_id_usecase.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late GetTransactionByIdUseCase useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = GetTransactionByIdUseCase(mockRepository);
  });

  final tTransaction = TransactionEntity(
    id: '1',
    amount: 25000,
    customerName: 'John Doe',
    type: TransactionType.deposit,
    date: DateTime(2026, 5, 19),
  );

  group('GetTransactionByIdUseCase', () {
    test('should return transaction for the given id', () async {
      when(() => mockRepository.getTransactionById('1'))
          .thenAnswer((_) async => tTransaction);

      final result = await useCase('1');

      expect(result, equals(tTransaction));
      verify(() => mockRepository.getTransactionById('1')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should propagate StateError when transaction not found', () async {
      when(() => mockRepository.getTransactionById('999'))
          .thenThrow(StateError('Transaction 999 not found'));

      expect(() => useCase('999'), throwsA(isA<StateError>()));
    });
  });
}
