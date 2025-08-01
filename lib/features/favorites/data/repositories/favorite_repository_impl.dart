import 'package:hive/hive.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../models/favorite_item_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final Box<FavoriteItemModel> favoriteBox;

  FavoriteRepositoryImpl(this.favoriteBox);

  @override
  Future<List<FavoriteItem>> getFavorites() async {
    return favoriteBox.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addFavorite(FavoriteItem item) async {
    await favoriteBox.put(
      item.productId.toString(),
      FavoriteItemModel.fromEntity(item),
    );
  }

  @override
  Future<void> removeFavorite(int productId) async {
    await favoriteBox.delete(productId.toString());
  }

  @override
  Future<bool> isFavorite(int productId) async {
    return favoriteBox.containsKey(productId.toString());
  }
}
