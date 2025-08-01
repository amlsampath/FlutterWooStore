import 'package:equatable/equatable.dart';
import '../../domain/entities/billing_info.dart' as billing;
import '../../domain/entities/shipping_info.dart';
import '../../domain/entities/checkout_info.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutEventLoad extends CheckoutEvent {
  const CheckoutEventLoad();
}

class CheckoutEventUpdateShippingInfo extends CheckoutEvent {
  final ShippingInfo shippingInfo;

  const CheckoutEventUpdateShippingInfo(this.shippingInfo);

  @override
  List<Object?> get props => [shippingInfo];
}

class CheckoutEventUpdateBillingInfo extends CheckoutEvent {
  final billing.BillingInfo billingInfo;

  const CheckoutEventUpdateBillingInfo(this.billingInfo);

  @override
  List<Object?> get props => [billingInfo];
}

class CheckoutEventUpdateShippingMethod extends CheckoutEvent {
  final ShippingMethod shippingMethod;

  const CheckoutEventUpdateShippingMethod(this.shippingMethod);

  @override
  List<Object?> get props => [shippingMethod];
}

class CheckoutEventPlaceOrder extends CheckoutEvent {
  const CheckoutEventPlaceOrder();
}
