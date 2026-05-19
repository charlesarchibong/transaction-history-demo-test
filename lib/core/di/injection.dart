import 'package:flutter/services.dart';

import '../../features/transaction/data/data_sources/transaction_local_data_source.dart';
import '../../features/transaction/data/repositories/transaction_repository_impl.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/transaction/domain/usecases/get_transaction_by_id_usecase.dart';
import '../../features/transaction/domain/usecases/get_transactions_usecase.dart';
import '../../features/transaction/presentation/manager/transaction_bloc.dart';

class Injection {
  Injection._();

  static final TransactionLocalDataSource _localDataSource = TransactionLocalDataSourceImpl(assetBundle: rootBundle);

  static final TransactionRepository _repository = TransactionRepositoryImpl(localDataSource: _localDataSource);

  static final GetTransactionsUseCase _getTransactions = GetTransactionsUseCase(_repository);

  static final GetTransactionByIdUseCase _getTransactionById = GetTransactionByIdUseCase(_repository);

  static TransactionBloc transactionBloc() => TransactionBloc(getTransactions: _getTransactions, getTransactionById: _getTransactionById);
}
