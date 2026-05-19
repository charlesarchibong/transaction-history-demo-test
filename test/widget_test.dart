import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_test/features/transaction/presentation/manager/transaction_bloc.dart';
import 'package:demo_test/features/transaction/presentation/pages/transaction_history_page.dart';

class MockTransactionBloc
    extends MockBloc<TransactionEvent, TransactionState>
    implements TransactionBloc {}

void main() {
  testWidgets('app smoke test: history page renders app bar title',
      (tester) async {
    final mockBloc = MockTransactionBloc();
    when(() => mockBloc.state)
        .thenReturn(const TransactionsLoaded([]));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<TransactionBloc>.value(
          value: mockBloc,
          child: const TransactionHistoryPage(),
        ),
      ),
    );

    expect(find.text('Transaction History'), findsOneWidget);

    await mockBloc.close();
  });
}
