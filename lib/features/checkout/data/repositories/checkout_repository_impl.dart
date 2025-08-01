import 'package:hive/hive.dart';
import '../../domain/entities/billing_info.dart';
import '../../domain/entities/shipping_info.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../models/billing_info_model.dart';
import '../models/shipping_info_model.dart';
import '../models/order_details_model.dart';
import '../datasources/checkout_remote_data_source.dart';
import '../../../cart/data/models/cart_item_model.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;
  final Box<BillingInfoModel> billingBox;
  final Box<ShippingInfoModel> shippingBox;
  final Box<CartItemModel> cartBox;
  final AuthRepository authRepository;

  CheckoutRepositoryImpl({
    required this.remoteDataSource,
    required this.billingBox,
    required this.cartBox,
    required this.authRepository,
    required this.shippingBox,
  });

  @override
  Future<bool> validateCoupon(String code) async {
    return remoteDataSource.validateCoupon(code);
  }

  @override
  Future<Map<String, dynamic>> createOrder({
    required BillingInfo billingInfo,
    ShippingInfo? shippingInfo,
    required String shippingMethodId,
    required String paymentMethodId,
    String? couponCode,
    String? orderNotes,
    int? customerId,
  }) async {
    final cartItems = cartBox.values.toList();

    // If no shipping info provided, use billing info
    final shipping = shippingInfo ??
        ShippingInfo(
          firstName: billingInfo.firstName,
          lastName: billingInfo.lastName,
          phone: billingInfo.phone,
          address: billingInfo.address,
          city: billingInfo.city,
          state: billingInfo.state,
          zip: billingInfo.zip,
        );

    // Find the payment method title from the loaded payment methods
    final paymentMethods = await getPaymentMethods();
    final paymentMethod = paymentMethods.firstWhere(
      (m) => m['id'] == paymentMethodId,
      orElse: () => <String, dynamic>{},
    );
    final paymentMethodTitle = paymentMethod['title'] ?? paymentMethodId;

    // Get shipping method details
    final shippingMethods = await getShippingMethods();
    final shippingMethod = shippingMethods.firstWhere(
      (m) => m['id'] == shippingMethodId,
      orElse: () => <String, dynamic>{},
    );
    final shippingMethodTitle = shippingMethod['title'] ?? 'Standard Shipping';
    final shippingTotal = shippingMethod['cost']?.toString() ?? '0.00';

    final orderData = {
      'payment_method': paymentMethodId,
      'payment_method_title': paymentMethodTitle,
      'set_paid': false,
      'customer_id': customerId,
      'billing': {
        'first_name': billingInfo.firstName,
        'last_name': billingInfo.lastName,
        'address_1': billingInfo.address,
        'city': billingInfo.city,
        'state': billingInfo.state,
        'postcode': billingInfo.zip,
        'email': billingInfo.email,
        'phone': billingInfo.phone,
      },
      'shipping': {
        'first_name': shipping.firstName,
        'last_name': shipping.lastName,
        'address_1': shipping.address,
        'city': shipping.city,
        'state': shipping.state,
        'postcode': shipping.zip,
      },
      'line_items': cartItems
          .map((item) => {
                'product_id': item.productId,
                'quantity': item.quantity,
                'name': item.name,
                'price': item.price,
                'total': (double.parse(item.price) * item.quantity).toString(),
              })
          .toList(),
      'shipping_lines': [
        {
          'method_id': shippingMethodId,
          'method_title': shippingMethodTitle,
          'total': shippingTotal,
        }
      ],
      'coupon_lines': couponCode != null
          ? [
              {
                'code': couponCode,
              }
            ]
          : [],
      'customer_note': orderNotes,
    };

    final response = await remoteDataSource.createOrder(orderData: orderData);

    // Clear the cart after successful order creation
    await cartBox.clear();

    return response;
  }

  @override
  Future<Map<String, dynamic>> updateOrderAfterPayment(String orderId) async {
    final updateData = {
      'set_paid': true,
      'payment_method': 'payhere',
      'payment_method_title': 'PayHere',
      'status': 'processing'
    };

    return remoteDataSource.updateOrder(
        orderId: orderId, orderData: updateData);
  }

  @override
  Future<Map<String, dynamic>> updateOrder({
    required String orderId,
    required Map<String, dynamic> orderData,
  }) async {
    // Forward the request to the remote data source
    return remoteDataSource.updateOrder(orderId: orderId, orderData: orderData);
  }

  @override
  Future<List<Map<String, dynamic>>> getShippingMethods() async {
    return remoteDataSource.getShippingMethods();
  }

  @override
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    return remoteDataSource.getPaymentMethods();
  }

  @override
  Future<void> saveBillingInfo(BillingInfo billingInfo) async {
    try {
      // Always save billing info locally for convenience
      final model = BillingInfoModel.fromEntity(billingInfo);
      await billingBox.put('billing_info', model);

      // If the user is logged in, also update their WooCommerce profile
      final currentUserResult = await authRepository.getCurrentUser();
      currentUserResult.fold(
        (failure) => null, // Do nothing if user is not logged in
        (user) async {
          // Update billing info in WooCommerce
          await updateCustomerBillingInfo(
            customerId: user.id,
            billingInfo: billingInfo,
          );
        },
      );
    } catch (e) {
      throw Exception('Failed to save billing info: $e');
    }
  }

  @override
  Future<bool> updateCustomerBillingInfo({
    required int customerId,
    required BillingInfo billingInfo,
  }) async {
    try {
      final billingData = {
        'first_name': billingInfo.firstName,
        'last_name': billingInfo.lastName,
        'address_1': billingInfo.address,
        'city': billingInfo.city,
        'state': billingInfo.state,
        'postcode': billingInfo.zip,
        'email': billingInfo.email,
        'phone': billingInfo.phone,
      };

      return await remoteDataSource.updateCustomerBillingInfo(
        customerId: customerId,
        billingData: billingData,
      );
    } catch (e) {
      throw Exception('Failed to update customer billing info: $e');
    }
  }

  @override
  Future<BillingInfo?> getBillingInfo() async {
    final model = billingBox.get('billing_info');
    return model?.toEntity();
  }

  @override
  Future<List<Order>> getOrders({int? customerId}) async {
    try {
      final response = await remoteDataSource.getOrders(customerId: customerId);
      return response.map<Order>((orderData) {
        final billingData = orderData['billing'] as Map<String, dynamic>? ?? {};
        // Calculate subtotal from line_items
        double subtotal = 0.0;
        if (orderData['line_items'] != null &&
            orderData['line_items'] is List) {
          for (final item in orderData['line_items']) {
            final itemSubtotal =
                double.tryParse(item['subtotal']?.toString() ?? '0') ?? 0.0;
            subtotal += itemSubtotal;
          }
        }
        return Order(
          id: orderData['id'] as int,
          status: orderData['status'] as String? ?? 'pending',
          total: orderData['total'] as String? ?? '0.00',
          subtotal: subtotal.toStringAsFixed(2),
          tax: orderData['total_tax'] as String? ?? '0.00',
          shippingTotal: orderData['shipping_total'] as String? ?? '0.00',
          discountTotal: orderData['discount_total'] != null
              ? orderData['discount_total'].toString()
              : '0.00',
          paymentMethod: orderData['payment_method'] as String? ?? '',
          paymentMethodTitle:
              orderData['payment_method_title'] as String? ?? '',
          dateCreated: DateTime.parse(orderData['date_created'] as String? ??
              DateTime.now().toIso8601String()),
          billingInfo: BillingInfo(
            firstName: billingData['first_name'] as String? ?? '',
            lastName: billingData['last_name'] as String? ?? '',
            email: billingData['email'] as String? ?? '',
            phone: billingData['phone'] as String? ?? '',
            address: billingData['address_1'] as String? ?? '',
            city: billingData['city'] as String? ?? '',
            state: billingData['state'] as String? ?? '',
            zip: billingData['postcode'] as String? ?? '',
          ),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  @override
  Future<OrderDetails> getOrderDetails(int orderId) async {
    try {
      // First get the order to have basic order information
      final orders = await getOrders();
      final order = orders.firstWhere(
        (order) => order.id == orderId,
        orElse: () => throw Exception('Order not found'),
      );

      // Then get detailed order information
      final orderData = await remoteDataSource.getOrderDetails(orderId);

      // Map the response to OrderDetails entity
      return OrderDetailsModel.fromJson(orderData, order).toEntity();
    } catch (e) {
      throw Exception('Failed to get order details: $e');
    }
  }

  @override
  Future<void> saveShippingInfo(ShippingInfo shippingInfo) async {
    try {
      // Always save shipping info locally for convenience
      final model = ShippingInfoModel.fromEntity(shippingInfo);
      await shippingBox.put('shipping_info', model);

      // If the user is logged in, also update their WooCommerce profile
      final currentUserResult = await authRepository.getCurrentUser();
      currentUserResult.fold(
        (failure) => null, // Do nothing if user is not logged in
        (user) async {
          // Update shipping info in WooCommerce
          await updateCustomerShippingInfo(
            customerId: user.id,
            shippingInfo: shippingInfo,
          );
        },
      );
    } catch (e) {
      throw Exception('Failed to save shipping info: $e');
    }
  }

  @override
  Future<ShippingInfo?> getShippingInfo() async {
    final model = shippingBox.get('shipping_info');
    return model?.toEntity();
  }

  @override
  Future<bool> updateCustomerShippingInfo({
    required int customerId,
    required ShippingInfo shippingInfo,
  }) async {
    try {
      final shippingData = {
        'first_name': shippingInfo.firstName,
        'last_name': shippingInfo.lastName,
        'address_1': shippingInfo.address,
        'city': shippingInfo.city,
        'state': shippingInfo.state,
        'postcode': shippingInfo.zip,
        'phone': shippingInfo.phone,
      };

      return await remoteDataSource.updateCustomerShippingInfo(
        customerId: customerId,
        shippingData: shippingData,
      );
    } catch (e) {
      throw Exception('Failed to update customer shipping info: $e');
    }
  }
}
