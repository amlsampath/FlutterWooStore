import 'package:equatable/equatable.dart';
import '../../domain/entities/checkout_info.dart';
import '../../domain/entities/shipping_info.dart';
import '../../domain/entities/billing_info.dart' as billing;

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutFormState extends CheckoutState {
  final billing.BillingInfo? billingInfo;
  final ShippingInfo? shippingInfo;
  final String? statusMessage;
  final bool isLoading;
  final String? errorMessage;

  const CheckoutFormState({
    this.billingInfo,
    this.shippingInfo,
    this.statusMessage,
    this.isLoading = false,
    this.errorMessage,
  });

  CheckoutFormState copyWith({
    billing.BillingInfo? billingInfo,
    ShippingInfo? shippingInfo,
    String? statusMessage,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CheckoutFormState(
      billingInfo: billingInfo ?? this.billingInfo,
      shippingInfo: shippingInfo ?? this.shippingInfo,
      statusMessage: statusMessage,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props =>
      [billingInfo, shippingInfo, statusMessage, isLoading, errorMessage];
}

class CheckoutStateInitial extends CheckoutState {
  const CheckoutStateInitial();
}

class CheckoutStateLoading extends CheckoutState {
  const CheckoutStateLoading();
}

class CheckoutStateLoaded extends CheckoutState {
  final CheckoutInfo checkoutInfo;

  const CheckoutStateLoaded(this.checkoutInfo);

  @override
  List<Object?> get props => [checkoutInfo];
}

class CheckoutStateError extends CheckoutState {
  final String message;

  const CheckoutStateError(this.message);

  @override
  List<Object?> get props => [message];
}

class BillingInfoSaving extends CheckoutState {
  const BillingInfoSaving();
}

class BillingInfoSaveError extends CheckoutState {
  final String message;
  const BillingInfoSaveError(this.message);

  @override
  List<Object?> get props => [message];
}

class ShippingInfoUpdating extends CheckoutState {
  const ShippingInfoUpdating();
}

class ShippingInfoUpdateError extends CheckoutState {
  final String message;
  const ShippingInfoUpdateError(this.message);

  @override
  List<Object?> get props => [message];
}
