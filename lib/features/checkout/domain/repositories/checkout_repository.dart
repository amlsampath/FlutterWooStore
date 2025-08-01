import '../entities/billing_info.dart';
import '../entities/order.dart';
import '../entities/order_details.dart';
import '../entities/shipping_info.dart';

abstract class CheckoutRepository {
  Future<bool> validateCoupon(String code);
  Future<Map<String, dynamic>> createOrder({
    required BillingInfo billingInfo,
    ShippingInfo? shippingInfo,
    required String shippingMethodId,
    required String paymentMethodId,
    String? couponCode,
    String? orderNotes,
    int? customerId,
  });
  Future<Map<String, dynamic>> updateOrderAfterPayment(String orderId);

  // Generic method to update an order with custom data
  Future<Map<String, dynamic>> updateOrder({
    required String orderId,
    required Map<String, dynamic> orderData,
  });

  Future<List<Map<String, dynamic>>> getShippingMethods();
  Future<List<Map<String, dynamic>>> getPaymentMethods();
  Future<void> saveBillingInfo(BillingInfo billingInfo);
  Future<BillingInfo?> getBillingInfo();
  Future<void> saveShippingInfo(ShippingInfo shippingInfo);
  Future<ShippingInfo?> getShippingInfo();
  Future<List<Order>> getOrders({int? customerId});
  Future<OrderDetails> getOrderDetails(int orderId);

  // New method to update customer billing info in WooCommerce
  Future<bool> updateCustomerBillingInfo({
    required int customerId,
    required BillingInfo billingInfo,
  });

  // New method to update customer shipping info in WooCommerce
  Future<bool> updateCustomerShippingInfo({
    required int customerId,
    required ShippingInfo shippingInfo,
  });
}
