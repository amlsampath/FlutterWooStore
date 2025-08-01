import 'package:equatable/equatable.dart';
import 'billing_info.dart';

class Order extends Equatable {
  final int id;
  final String status;
  final String total;
  final String subtotal;
  final String tax;
  final String shippingTotal;
  final String? discountTotal;
  final String paymentMethod;
  final String paymentMethodTitle;
  final DateTime dateCreated;
  final BillingInfo billingInfo;

  const Order({
    required this.id,
    required this.status,
    required this.total,
    required this.subtotal,
    required this.tax,
    required this.shippingTotal,
    this.discountTotal,
    required this.paymentMethod,
    required this.paymentMethodTitle,
    required this.dateCreated,
    required this.billingInfo,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        total,
        subtotal,
        tax,
        shippingTotal,
        discountTotal,
        paymentMethod,
        paymentMethodTitle,
        dateCreated,
        billingInfo,
      ];
}
