import 'package:equatable/equatable.dart';

class PaymentResponse extends Equatable {
  final String status;
  final String message;
  final String? transactionId;
  final String? orderId;

  const PaymentResponse({
    required this.status,
    required this.message,
    this.transactionId,
    this.orderId,
  });

  @override
  List<Object?> get props => [status, message, transactionId, orderId];
}
