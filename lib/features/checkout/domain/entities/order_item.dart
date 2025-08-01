import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final int id;
  final int productId;
  final String name;
  final int quantity;
  final String price;
  final String total;
  final String? imageUrl;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.quantity,
    required this.price,
    required this.total,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        productId,
        name,
        quantity,
        price,
        total,
        imageUrl,
      ];
}
