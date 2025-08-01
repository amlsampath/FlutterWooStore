import '../entities/favorite_item.dart';

abstract class FavoriteRepository {
  Future<List<FavoriteItem>> getFavorites();
  Future<void> addFavorite(FavoriteItem item);
  Future<void> removeFavorite(int productId);
  Future<bool> isFavorite(int productId);
}
