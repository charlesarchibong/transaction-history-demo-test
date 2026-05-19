import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_test/features/transaction/domain/entities/transaction_entity.dart';
import 'package:demo_test/features/transaction/domain/usecases/get_transaction_by_id_usecase.dart';
import 'package:demo_test/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:demo_test/features/transaction/presentation/manager/transaction_bloc.dart';

class MockGetTransactionsUseCase extends Mock
    implements GetTransactionsUseCase {}

class MockGetTransactionByIdUseCase extends Mock
    implements GetTransactionByIdUseCase {}

void main() {
  late TransactionBloc bloc;
  late MockGetTransactionsUseCase mockGetTransactions;
  late MockGetTransactionByIdUseCase mockGetTransactionById;

  final tTransactions = [
    TransactionEntity(
      id: '1',
      amount: 25000,
      customerName: 'John Doe',
      type: TransactionType.deposit,
      date: DateTime(2026, 5, 19),
    ),
    TransactionEntity(
      id: '2',
      amount: 12000,
      customerName: 'Alice Smith',
      type: TransactionType.withdrawal,
      date: DateTime(2026, 5, 18),
    ),
  ];

  setUp(() {
    mockGetTransactions = MockGetTransactionsUseCase();
    mockGetTransactionById = MockGetTransactionByIdUseCase();
    bloc = TransactionBloc(
      getTransactions: mockGetTransactions,
      getTransactionById: mockGetTransactionById,
    );
  });

  tearDown(() => bloc.close());

  test('initial state is TransactionInitial', () {
    expect(bloc.state, const TransactionInitial());
  });

  group('LoadTransactions', () {
    blocTest<TransactionBloc, TransactionState>(
      'emits [Loading, Loaded] when transactions fetch succeeds',
      build: () {
        when(() => mockGetTransactions())
            .thenAnswer((_) async => tTransactions);
        return bloc;
      },
      act: (b) => b.add(const LoadTransactions()),
      expect: () => [
        const TransactionLoading(),
        TransactionsLoaded(tTransactions),
      ],
      verify: (_) => verify(() => mockGetTransactions()).called(1),
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits [Loading, Error] when transactions fetch throws',
      build: () {
        when(() => mockGetTransactions())
            .thenThrow(Exception('Network error'));
        return bloc;
      },
      act: (b) => b.add(const LoadTransactions()),
      expect: () => [
        const TransactionLoading(),
        isA<TransactionError>(),
      ],
    );
  });

  group('LoadTransactionDetail', () {
    blocTest<TransactionBloc, TransactionState>(
      'emits [Loading, DetailLoaded] when fetch by id succeeds',
      build: () {
        when(() => mockGetTransactionById('1'))
            .thenAnswer((_) async => tTransactions[0]);
        return bloc;
      },
      act: (b) => b.add(const LoadTransactionDetail('1')),
      expect: () => [
        const TransactionLoading(),
        TransactionDetailLoaded(tTransactions[0]),
      ],
      verify: (_) =>
          verify(() => mockGetTransactionById('1')).called(1),
    );

    blocTest<TransactionBloc, TransactionState>(
      'emits [Loading, Error] when id not found',
      build: () {
        when(() => mockGetTransactionById('999'))
            .thenThrow(StateError('Transaction 999 not found'));
        return bloc;
      },
      act: (b) => b.add(const LoadTransactionDetail('999')),
      expect: () => [
        const TransactionLoading(),
        isA<TransactionError>(),
      ],
    );
  });
}
