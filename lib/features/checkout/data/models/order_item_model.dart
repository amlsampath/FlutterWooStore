import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.productId,
    required super.name,
    required super.quantity,
    required super.price,
    required super.total,
    super.imageUrl,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      productId: json['product_id'] as int,
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 0,
      price: json['price'] != null ? json['price'].toString() : '0.00',
      total: json['total'] != null ? json['total'].toString() : '0.00',
      imageUrl: json['image']?['src'] as String?,
    );
  }

  OrderItem toEntity() => this;
}
