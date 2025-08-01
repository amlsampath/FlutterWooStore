import '../entities/browsing_history_item.dart';
import '../repositories/browsing_history_repository.dart';

class GetBrowsingHistoryUseCase {
  final BrowsingHistoryRepository repository;

  GetBrowsingHistoryUseCase(this.repository);

  Future<List<BrowsingHistoryItem>> execute() {
    return repository.getBrowsingHistory();
  }
}
