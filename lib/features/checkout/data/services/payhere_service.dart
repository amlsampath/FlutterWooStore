import 'package:payhere_mobilesdk_flutter/payhere_mobilesdk_flutter.dart';
import '../../domain/entities/payment_response.dart';
import '../../domain/entities/billing_info.dart';
import '../../domain/entities/shipping_info.dart';
import '../../../../core/config/app_config.dart';
import 'dart:async';

class PayHereService {
  Future<PaymentResponse> initiatePayment({
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
      Map paymentObject = {
        "sandbox": AppConfig.payHereIsSandbox,
        "merchant_id": AppConfig.payHereMerchantId,
        "merchant_secret": AppConfig.payHereMerchantSecret,
        "notify_url": "",
        "order_id": orderId,
        "items": "Order #$orderId",
        "amount": amount.toString(),
        "currency": currency,
        "first_name": customerName.split(' ').first,
        "last_name": customerName.split(' ').last,
        "email": customerEmail,
        "phone": customerPhone,
        "address": billingInfo.address,
        "city": billingInfo.city,
        "country": "Sri Lanka", // Default country for PayHere
        "delivery_address": shippingInfo.address,
        "delivery_city": shippingInfo.city,
        "delivery_country": "Sri Lanka", // Default country for PayHere
        "custom_1": "",
        "custom_2": ""
      };

      Completer<PaymentResponse> completer = Completer<PaymentResponse>();

      PayHere.startPayment(
        paymentObject,
        (paymentId) {
          completer.complete(PaymentResponse(
            status: 'SUCCESS',
            message: 'Payment successful',
            transactionId: paymentId,
            orderId: orderId,
          ));
        },
        (error) {
          completer.complete(PaymentResponse(
            status: 'FAILED',
            message: error,
            orderId: orderId,
          ));
        },
        () {
          completer.complete(PaymentResponse(
            status: 'DISMISSED',
            message: 'Payment dismissed by user',
            orderId: orderId,
          ));
        },
      );

      return completer.future;
    } catch (e) {
      throw Exception('Failed to initiate PayHere payment: $e');
    }
  }
}
