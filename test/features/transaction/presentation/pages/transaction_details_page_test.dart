import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_test/features/transaction/domain/entities/transaction_entity.dart';
import 'package:demo_test/features/transaction/presentation/manager/transaction_bloc.dart';
import 'package:demo_test/features/transaction/presentation/pages/transaction_details_page.dart';

class MockTransactionBloc
    extends MockBloc<TransactionEvent, TransactionState>
    implements TransactionBloc {}

void main() {
  late MockTransactionBloc mockBloc;

  final tTransaction = TransactionEntity(
    id: '1',
    amount: 25000,
    customerName: 'John Doe',
    type: TransactionType.deposit,
    date: DateTime(2026, 5, 19, 10),
  );

  setUp(() => mockBloc = MockTransactionBloc());
  tearDown(() => mockBloc.close());

  Widget buildSubject() => MaterialApp(
    home: BlocProvider<TransactionBloc>.value(
      value: mockBloc,
      child: const TransactionDetailsPage(transactionId: '1'),
    ),
  );

  group('TransactionDetailsPage', () {
    testWidgets('dispatches LoadTransactionDetail on init', (tester) async {
      when(() => mockBloc.state).thenReturn(const TransactionInitial());

      await tester.pumpWidget(buildSubject());

      verify(() => mockBloc.add(const LoadTransactionDetail('1'))).called(1);
    });

    testWidgets('shows loading indicator when state is loading',
        (tester) async {
      when(() => mockBloc.state).thenReturn(const TransactionLoading());

      await tester.pumpWidget(buildSubject());

      expect(find.byKey(const Key('detail_loading')), findsOneWidget);
    });

    testWidgets('shows transaction detail card when loaded', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(TransactionDetailLoaded(tTransaction));

      await tester.pumpWidget(buildSubject());

      expect(
        find.byKey(const Key('transaction_detail_card')),
        findsOneWidget,
      );
      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('shows error when detail load fails', (tester) async {
      when(() => mockBloc.state)
          .thenReturn(const TransactionError('Not found'));

      await tester.pumpWidget(buildSubject());

      expect(find.byKey(const Key('detail_error')), findsOneWidget);
      expect(find.text('Not found'), findsOneWidget);
    });
  });
}
