import '../../domain/entities/payment_response.dart';
import '../../domain/entities/billing_info.dart';
import '../../domain/entities/shipping_info.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
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
      final response = await remoteDataSource.initiatePayment(
        orderId: orderId,
        amount: amount,
        customerName: customerName,
        customerEmail: customerEmail,
        customerPhone: customerPhone,
        currency: currency,
        billingInfo: billingInfo,
        shippingInfo: shippingInfo,
      );
      return response;
    } catch (e) {
      throw Exception('Failed to process payment: $e');
    }
  }
}
