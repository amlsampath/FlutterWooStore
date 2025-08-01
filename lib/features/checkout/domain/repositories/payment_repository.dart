import '../entities/payment_response.dart';

import '../entities/billing_info.dart';
import '../entities/shipping_info.dart';

abstract class PaymentRepository {
  Future<PaymentResponse> initiatePayment({
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
