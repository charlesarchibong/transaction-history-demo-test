part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

class LoadTransactionDetail extends TransactionEvent {
  final String id;

  const LoadTransactionDetail(this.id);

  @override
  List<Object?> get props => [id];
}
