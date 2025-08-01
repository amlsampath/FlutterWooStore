import 'package:hive/hive.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final Box<CartItemModel> cartBox;

  CartRepositoryImpl(this.cartBox);

  @override
  Future<List<CartItem>> getCartItems() async {
    return cartBox.values.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addCartItem(CartItem item) async {
    final existingItem = cartBox.values.firstWhere(
      (model) => model.productId == item.productId,
      orElse: () => CartItemModel(
        productId: -1,
        name: '',
        imageUrl: '',
        price: '',
        quantity: 0,
      ),
    );

    if (existingItem.productId != -1) {
      existingItem.quantity = item.quantity;
      await existingItem.save();
    } else {
      await cartBox.add(CartItemModel.fromEntity(item));
    }
  }

  @override
  Future<void> removeCartItem(int productId) async {
    final key = cartBox.values.toList().indexWhere(
          (model) => model.productId == productId,
        );
    if (key != -1) {
      await cartBox.deleteAt(key);
    }
  }

  @override
  Future<void> removeCartItems(List<int> productIds) async {
    final items = cartBox.values.toList();
    final keysToDelete = <int>[];
    for (var i = 0; i < items.length; i++) {
      if (productIds.contains(items[i].productId)) {
        keysToDelete.add(i);
      }
    }
    for (final key in keysToDelete.reversed) {
      await cartBox.deleteAt(key);
    }
  }

  @override
  Future<void> clearCart() async {
    await cartBox.clear();
  }
}
