import 'package:hive/hive.dart';
import '../../domain/entities/favorite_item.dart';

part 'favorite_item_model.g.dart';

@HiveType(typeId: 1)
class FavoriteItemModel extends HiveObject {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String price;

  FavoriteItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  factory FavoriteItemModel.fromEntity(FavoriteItem item) => FavoriteItemModel(
        productId: item.productId,
        name: item.name,
        imageUrl: item.imageUrl,
        price: item.price,
      );

  FavoriteItem toEntity() => FavoriteItem(
        productId: productId,
        name: name,
        imageUrl: imageUrl,
        price: price,
      );
}
