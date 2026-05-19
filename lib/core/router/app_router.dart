import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/transaction/presentation/pages/transaction_details_page.dart';
import '../../features/transaction/presentation/pages/transaction_history_page.dart';
import '../di/injection.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => BlocProvider(
        create: (_) => Injection.transactionBloc(),
        child: const TransactionHistoryPage(),
      ),
    ),
    GoRoute(
      path: '/transactions/:id',
      builder: (_, state) => BlocProvider(
        create: (_) => Injection.transactionBloc(),
        child: TransactionDetailsPage(
          transactionId: state.pathParameters['id']!,
        ),
      ),
    ),
  ],
);
