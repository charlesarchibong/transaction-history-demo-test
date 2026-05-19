import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionByIdUseCase {
  final TransactionRepository repository;

  const GetTransactionByIdUseCase(this.repository);

  Future<TransactionEntity> call(String id) => repository.getTransactionById(id);
}
