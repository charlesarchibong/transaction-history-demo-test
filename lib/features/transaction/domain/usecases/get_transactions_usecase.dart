import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionsUseCase {
  final TransactionRepository repository;

  const GetTransactionsUseCase(this.repository);

  Future<List<TransactionEntity>> call() => repository.getTransactions();
}
