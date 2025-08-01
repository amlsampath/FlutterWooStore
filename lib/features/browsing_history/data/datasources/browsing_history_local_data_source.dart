import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/browsing_history_item_model.dart';

abstract class BrowsingHistoryLocalDataSource {
  Future<void> addProductToHistory(BrowsingHistoryItemModel item);
  Future<List<BrowsingHistoryItemModel>> getBrowsingHistory();
  Future<void> clearBrowsingHistory();
}

class BrowsingHistoryLocalDataSourceImpl
    implements BrowsingHistoryLocalDataSource {
  static const String _historyKey = 'browsing_history';
  final Future<SharedPreferences> _prefs;

  BrowsingHistoryLocalDataSourceImpl(this._prefs);

  @override
  Future<void> addProductToHistory(BrowsingHistoryItemModel item) async {
    final prefs = await _prefs;
    final history = await getBrowsingHistory();
    // Remove if already exists (by id)
    final updated = [item, ...history.where((e) => e.id != item.id)];
    // Limit to 20 items
    final limited = updated.take(20).toList();
    final jsonList = limited.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_historyKey, jsonList);
  }

  @override
  Future<List<BrowsingHistoryItemModel>> getBrowsingHistory() async {
    final prefs = await _prefs;
    final jsonList = prefs.getStringList(_historyKey) ?? [];
    return jsonList
        .map((e) => BrowsingHistoryItemModel.fromJson(json.decode(e)))
        .toList();
  }

  @override
  Future<void> clearBrowsingHistory() async {
    final prefs = await _prefs;
    await prefs.remove(_historyKey);
  }
}
