import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_test/features/transaction/domain/entities/transaction_entity.dart';
import 'package:demo_test/features/transaction/presentation/manager/transaction_bloc.dart';
import 'package:demo_test/features/transaction/presentation/pages/transaction_history_page.dart';

class MockTransactionBloc
    extends MockBloc<TransactionEvent, TransactionState>
    implements TransactionBloc {}

void main() {
  late MockTransactionBloc mockBloc;

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

  setUp(() => mockBloc = MockTransactionBloc());
  tearDown(() => mockBloc.close());

  Widget buildSubject() => MaterialApp(
    home: BlocProvider<TransactionBloc>.value(
      value: mockBloc,
      child: const TransactionHistoryPage(),
    ),
  );

  group('TransactionHistoryPage', () {
    testWidgets('dispatches LoadTransactions on init', (tester) async {
      when(() => mockBloc.state).thenReturn(const TransactionInitial());

      await tester.pumpWidget(buildSubject());

      verify(() => mockBloc.add(const LoadTransactions())).called(1);
    });

    testWidgets('shows loading indicator when state is loading',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const TransactionLoading());

      await tester.pumpWidget(buildSubject());

      expect(find.byKey(const Key('loading_indicator')), findsOneWidget);
    });

    testWidgets('shows transaction list when state is loaded', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(TransactionsLoaded(tTransactions));

      await tester.pumpWidget(buildSubject());

      expect(find.byKey(const Key('transaction_list')), findsOneWidget);
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('Alice Smith'), findsOneWidget);
    });

    testWidgets('shows empty state when no transactions', (tester) async {
      when(() => mockBloc.state).thenReturn(const TransactionsLoaded([]));

      await tester.pumpWidget(buildSubject());

      expect(find.byKey(const Key('empty_state')), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const TransactionError('Network error'));

      await tester.pumpWidget(buildSubject());

      expect(find.byKey(const Key('error_state')), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('tapping Retry dispatches LoadTransactions', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const TransactionError('Network error'));

      await tester.pumpWidget(buildSubject());
      await tester.tap(find.text('Retry'));

      // called once on init + once on retry tap
      verify(() => mockBloc.add(const LoadTransactions())).called(2);
    });
  });
}
