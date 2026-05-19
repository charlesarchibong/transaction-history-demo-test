import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/get_transaction_by_id_usecase.dart';
import '../../domain/usecases/get_transactions_usecase.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactionsUseCase getTransactions;
  final GetTransactionByIdUseCase getTransactionById;

  TransactionBloc({
    required this.getTransactions,
    required this.getTransactionById,
  }) : super(const TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadTransactionDetail>(_onLoadTransactionDetail);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    try {
      final transactions = await getTransactions();
      emit(TransactionsLoaded(transactions));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  Future<void> _onLoadTransactionDetail(
    LoadTransactionDetail event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    try {
      final transaction = await getTransactionById(event.id);
      emit(TransactionDetailLoaded(transaction));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }
}
