import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int productId;
  final String name;
  final String imageUrl;
  final String price;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final Map<String, String>? additionalAttributes;
  final bool selected;

  const CartItem({
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    this.additionalAttributes,
    this.selected = false,
  });

  CartItem copyWith({
    int? productId,
    String? name,
    String? imageUrl,
    String? price,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
    Map<String, String>? additionalAttributes,
    bool? selected,
  }) {
    return CartItem(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      additionalAttributes: additionalAttributes ?? this.additionalAttributes,
      selected: selected ?? this.selected,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        name,
        imageUrl,
        price,
        quantity,
        selectedColor,
        selectedSize,
        additionalAttributes,
        selected,
      ];
}
