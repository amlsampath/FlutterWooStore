import 'package:hive/hive.dart';
import '../models/search_suggestion_model.dart';

abstract class SearchSuggestionLocalDataSource {
  Future<void> addSuggestion(String query);
  Future<List<SearchSuggestionModel>> getSuggestions(String prefix);
  Future<void> clearSuggestions();
}

class SearchSuggestionLocalDataSourceImpl
    implements SearchSuggestionLocalDataSource {
  final Box<SearchSuggestionModel> suggestionBox;

  SearchSuggestionLocalDataSourceImpl(this.suggestionBox);

  @override
  Future<void> addSuggestion(String query) async {
    final normalizedQuery = query.toLowerCase().trim();
    if (normalizedQuery.isEmpty) return;

    final existingSuggestion = suggestionBox.values.firstWhere(
      (suggestion) => suggestion.query.toLowerCase() == normalizedQuery,
      orElse: () => SearchSuggestionModel(
        query: normalizedQuery,
        lastUsed: DateTime.now(),
        useCount: 0,
      ),
    );

    if (existingSuggestion.useCount > 0) {
      // Update existing suggestion
      final updatedSuggestion = existingSuggestion.copyWith(
        lastUsed: DateTime.now(),
        useCount: existingSuggestion.useCount + 1,
      );
      await suggestionBox.put(normalizedQuery, updatedSuggestion);
    } else {
      // Add new suggestion
      await suggestionBox.put(
        normalizedQuery,
        SearchSuggestionModel(
          query: normalizedQuery,
          lastUsed: DateTime.now(),
          useCount: 1,
        ),
      );
    }
  }

  @override
  Future<List<SearchSuggestionModel>> getSuggestions(String prefix) async {
    final normalizedPrefix = prefix.toLowerCase().trim();
    if (normalizedPrefix.isEmpty) return [];

    final suggestions = suggestionBox.values
        .where((suggestion) =>
            suggestion.query.toLowerCase().contains(normalizedPrefix))
        .toList();

    // Sort by use count (descending) and last used (descending)
    suggestions.sort((a, b) {
      if (b.useCount != a.useCount) {
        return b.useCount.compareTo(a.useCount);
      }
      return b.lastUsed.compareTo(a.lastUsed);
    });

    return suggestions;
  }

  @override
  Future<void> clearSuggestions() async {
    await suggestionBox.clear();
  }
}
