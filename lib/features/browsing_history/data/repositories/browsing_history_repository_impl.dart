import '../../domain/entities/browsing_history_item.dart';
import '../../domain/repositories/browsing_history_repository.dart';
import '../datasources/browsing_history_local_data_source.dart';
import '../models/browsing_history_item_model.dart';

class BrowsingHistoryRepositoryImpl implements BrowsingHistoryRepository {
  final BrowsingHistoryLocalDataSource localDataSource;

  BrowsingHistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<void> addProductToHistory(BrowsingHistoryItem item) {
    return localDataSource.addProductToHistory(
      BrowsingHistoryItemModel.fromEntity(item),
    );
  }

  @override
  Future<List<BrowsingHistoryItem>> getBrowsingHistory() async {
    final models = await localDataSource.getBrowsingHistory();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> clearBrowsingHistory() {
    return localDataSource.clearBrowsingHistory();
  }
}
