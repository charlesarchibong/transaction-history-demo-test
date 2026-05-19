import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../data_sources/transaction_local_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;

  const TransactionRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TransactionEntity>> getTransactions() async {
    final models = await localDataSource.getTransactions();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<TransactionEntity> getTransactionById(String id) async {
    final models = await localDataSource.getTransactions();
    return models
        .map((m) => m.toEntity())
        .firstWhere(
          (e) => e.id == id,
          orElse: () => throw StateError('Transaction $id not found'),
        );
  }
}
