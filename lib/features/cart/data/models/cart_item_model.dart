import 'package:hive/hive.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  final int productId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final String price;

  @HiveField(4)
  int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromEntity(CartItem item) => CartItemModel(
        productId: item.productId,
        name: item.name,
        imageUrl: item.imageUrl,
        price: item.price,
        quantity: item.quantity,
      );

  CartItem toEntity() => CartItem(
        productId: productId,
        name: name,
        imageUrl: imageUrl,
        price: price,
        quantity: quantity,
      );
}
