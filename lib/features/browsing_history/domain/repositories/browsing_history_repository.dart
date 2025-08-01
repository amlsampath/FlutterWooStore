import '../entities/browsing_history_item.dart';

abstract class BrowsingHistoryRepository {
  Future<void> addProductToHistory(BrowsingHistoryItem item);
  Future<List<BrowsingHistoryItem>> getBrowsingHistory();
  Future<void> clearBrowsingHistory();
}
