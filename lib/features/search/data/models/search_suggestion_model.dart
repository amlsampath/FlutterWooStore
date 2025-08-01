import 'package:hive/hive.dart';

part 'search_suggestion_model.g.dart';

@HiveType(typeId: 5)
class SearchSuggestionModel extends HiveObject {
  @HiveField(0)
  final String query;

  @HiveField(1)
  final DateTime lastUsed;

  @HiveField(2)
  final int useCount;

  SearchSuggestionModel({
    required this.query,
    required this.lastUsed,
    required this.useCount,
  });

  SearchSuggestionModel copyWith({
    String? query,
    DateTime? lastUsed,
    int? useCount,
  }) {
    return SearchSuggestionModel(
      query: query ?? this.query,
      lastUsed: lastUsed ?? this.lastUsed,
      useCount: useCount ?? this.useCount,
    );
  }
}
