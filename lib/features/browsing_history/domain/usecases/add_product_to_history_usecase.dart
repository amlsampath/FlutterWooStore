import '../entities/browsing_history_item.dart';
import '../repositories/browsing_history_repository.dart';

class AddProductToHistoryUseCase {
  final BrowsingHistoryRepository repository;

  AddProductToHistoryUseCase(this.repository);

  Future<void> execute(BrowsingHistoryItem item) {
    return repository.addProductToHistory(item);
  }
}
