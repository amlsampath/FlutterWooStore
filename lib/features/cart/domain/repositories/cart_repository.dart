import '../entities/cart_item.dart';

abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addCartItem(CartItem item);
  Future<void> removeCartItem(int productId);

  /// Remove multiple cart items by their productIds
  Future<void> removeCartItems(List<int> productIds);
  Future<void> clearCart();
}
