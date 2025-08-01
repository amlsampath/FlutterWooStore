import 'package:dio/dio.dart';

abstract class CheckoutRemoteDataSource {
  Future<bool> validateCoupon(String code);
  Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> orderData,
  });
  Future<Map<String, dynamic>> updateOrder({
    required String orderId,
    required Map<String, dynamic> orderData,
  });
  Future<List<Map<String, dynamic>>> getShippingMethods();
  Future<List<Map<String, dynamic>>> getPaymentMethods();
  Future<List<Map<String, dynamic>>> getOrders({int? customerId});
  Future<Map<String, dynamic>> getOrderDetails(int orderId);

  // New method to update customer billing info
  Future<bool> updateCustomerBillingInfo({
    required int customerId,
    required Map<String, dynamic> billingData,
  });

  // New method to update customer shipping info
  Future<bool> updateCustomerShippingInfo({
    required int customerId,
    required Map<String, dynamic> shippingData,
  });
}

class CheckoutRemoteDataSourceImpl implements CheckoutRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  CheckoutRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
  });

  @override
  Future<bool> validateCoupon(String code) async {
    try {
      final response = await dio.get(
        '$baseUrl/wp-json/wc/v3/coupons',
        queryParameters: {
          'code': code,
        },
      );
      return response.data.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> createOrder({
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/wp-json/wc/v3/orders',
        data: orderData,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateOrder({
    required String orderId,
    required Map<String, dynamic> orderData,
  }) async {
    try {
      final response = await dio.put(
        '$baseUrl/wp-json/wc/v3/orders/$orderId',
        data: orderData,
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to update order: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getShippingMethods() async {
    try {
      final response = await dio.get(
        '$baseUrl/wp-json/wc/v3/shipping/zones',
      );

      final List<dynamic> zones = response.data;
      final List<Map<String, dynamic>> methods = [];

      for (final zone in zones) {
        final zoneId = zone['id'];
        if (zoneId == null) continue;

        try {
          final methodsResponse = await dio.get(
            '$baseUrl/wp-json/wc/v3/shipping/zones/$zoneId/methods',
          );

          final List<dynamic> methodsData = methodsResponse.data;

          for (final method in methodsData) {
            if (method == null) continue;

            // Safely extract data with null checks
            final Map<String, dynamic> methodMap = {
              'id': method['id']?.toString() ?? '',
              'title': method['title'] ?? 'Shipping Method',
              'description': method['description'] ?? '',
            };

            // Safely extract cost
            final settings = method['settings'] as Map<String, dynamic>?;
            if (settings != null) {
              final cost = settings['cost'] as Map<String, dynamic>?;
              if (cost != null) {
                methodMap['cost'] = cost['value'] ?? '0.00';
              } else {
                methodMap['cost'] = '0.00';
              }
            } else {
              methodMap['cost'] = '0.00';
            }

            methods.add(methodMap);
          }
        } catch (e) {
          print('Error fetching methods for zone $zoneId: $e');
          // Continue with next zone instead of breaking the whole operation
        }
      }

      return methods;
    } catch (e) {
      throw Exception('Failed to get shipping methods: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    try {
      final response = await dio.get(
        '$baseUrl/wp-json/wc/v3/payment_gateways',
      );

      return response.data.map<Map<String, dynamic>>((method) {
        return {
          'id': method['id'],
          'title': method['title'],
          'description': method['description'],
          'enabled': method['enabled'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Failed to get payment methods: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getOrders({int? customerId}) async {
    try {
      final queryParams = <String, dynamic>{};

      // Add customer ID to query params if provided
      if (customerId != null) {
        queryParams['customer'] = customerId;
      }

      final response = await dio.get(
        '$baseUrl/wp-json/wc/v3/orders',
        queryParameters: queryParams,
      );

      return List<Map<String, dynamic>>.from(response.data);
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getOrderDetails(int orderId) async {
    try {
      final response = await dio.get('$baseUrl/wp-json/wc/v3/orders/$orderId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch order details: $e');
    }
  }

  @override
  Future<bool> updateCustomerBillingInfo({
    required int customerId,
    required Map<String, dynamic> billingData,
  }) async {
    try {
      final response = await dio.put(
        '$baseUrl/wp-json/wc/v3/customers/$customerId',
        data: {
          'billing': billingData,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update customer billing info: $e');
    }
  }

  @override
  Future<bool> updateCustomerShippingInfo({
    required int customerId,
    required Map<String, dynamic> shippingData,
  }) async {
    try {
      final response = await dio.put(
        '$baseUrl/wp-json/wc/v3/customers/$customerId',
        data: {
          'shipping': shippingData,
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Failed to update customer shipping info: $e');
    }
  }
}
