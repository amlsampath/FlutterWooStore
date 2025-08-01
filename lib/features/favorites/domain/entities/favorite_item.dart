import 'package:equatable/equatable.dart';

class FavoriteItem extends Equatable {
  final int productId;
  final String name;
  final String imageUrl;
  final String price;

  const FavoriteItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
  });

  @override
  List<Object?> get props => [productId, name, imageUrl, price];
}
