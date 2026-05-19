import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../manager/transaction_bloc.dart';
import '../widgets/transaction_detail_card.dart';

class TransactionDetailsPage extends StatefulWidget {
  final String transactionId;

  const TransactionDetailsPage({required this.transactionId, super.key});

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<TransactionBloc>()
        .add(LoadTransactionDetail(widget.transactionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return const Center(
              child: CircularProgressIndicator(key: Key('detail_loading')),
            );
          }

          if (state is TransactionDetailLoaded) {
            return SingleChildScrollView(
              child: TransactionDetailCard(
                key: const Key('transaction_detail_card'),
                transaction: state.transaction,
              ),
            );
          }

          if (state is TransactionError) {
            return Center(
              key: const Key('detail_error'),
              child: Text(state.message),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
