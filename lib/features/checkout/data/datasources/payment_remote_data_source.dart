import 'package:dio/dio.dart';
import '../models/payment_response_model.dart';
import '../../domain/entities/billing_info.dart';
import '../../domain/entities/shipping_info.dart';

abstract class PaymentRemoteDataSource {
  Future<PaymentResponseModel> initiatePayment({
    required String orderId,
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String currency,
    required BillingInfo billingInfo,
    required ShippingInfo shippingInfo,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;
  final String baseUrl;
  final String merchantId;
  final String merchantSecret;
  final bool isSandbox;

  PaymentRemoteDataSourceImpl({
    required this.dio,
    required this.baseUrl,
    required this.merchantId,
    required this.merchantSecret,
    this.isSandbox = true,
  });

  @override
  Future<PaymentResponseModel> initiatePayment({
    required String orderId,
    required double amount,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String currency,
    required BillingInfo billingInfo,
    required ShippingInfo shippingInfo,
  }) async {
    try {
      final response = await dio.post(
        '$baseUrl/wp-json/wc/v3/payments',
        data: {
          'merchant_id': merchantId,
          'merchant_secret': merchantSecret,
          'amount': amount,
          'currency': currency,
          'order_id': orderId,
          'items_description': 'Order #$orderId',
          'customer_name': customerName,
          'customer_email': customerEmail,
          'customer_phone': customerPhone,
          'billing_address': billingInfo.address,
          'billing_city': billingInfo.city,
          'shipping_address': shippingInfo.address,
          'shipping_city': shippingInfo.city,
          'sandbox': isSandbox,
        },
      );

      return PaymentResponseModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }
}
