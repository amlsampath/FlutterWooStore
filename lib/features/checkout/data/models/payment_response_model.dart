import '../../domain/entities/payment_response.dart';

class PaymentResponseModel extends PaymentResponse {
  const PaymentResponseModel({
    required super.status,
    required super.message,
    super.transactionId,
    super.orderId,
  });

  factory PaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      transactionId: json['transaction_id'] as String?,
      orderId: json['order_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'transaction_id': transactionId,
      'order_id': orderId,
    };
  }
}
