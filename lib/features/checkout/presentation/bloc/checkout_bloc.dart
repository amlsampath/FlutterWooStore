import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/entities/billing_info.dart';
import '../../domain/entities/shipping_info.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_details.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../../domain/repositories/payment_repository.dart';
import '../../data/services/payhere_service.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

// Events
abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class LoadBillingInfo extends CheckoutEvent {}

class SaveBillingInfo extends CheckoutEvent {
  final BillingInfo billingInfo;

  const SaveBillingInfo(this.billingInfo);

  @override
  List<Object?> get props => [billingInfo];
}

class UpdateBillingInfo extends CheckoutEvent {
  final BillingInfo billingInfo;

  const UpdateBillingInfo(this.billingInfo);

  @override
  List<Object?> get props => [billingInfo];
}

class UpdateShippingMethod extends CheckoutEvent {
  final String methodId;

  const UpdateShippingMethod(this.methodId);

  @override
  List<Object?> get props => [methodId];
}

class UpdatePaymentMethod extends CheckoutEvent {
  final String methodId;

  const UpdatePaymentMethod(this.methodId);

  @override
  List<Object?> get props => [methodId];
}

class ApplyCoupon extends CheckoutEvent {
  final String code;

  const ApplyCoupon(this.code);

  @override
  List<Object?> get props => [code];
}

class UpdateOrderNotes extends CheckoutEvent {
  final String notes;

  const UpdateOrderNotes(this.notes);

  @override
  List<Object?> get props => [notes];
}

class PlaceOrder extends CheckoutEvent {
  final UserModel? currentUser;

  const PlaceOrder({this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}

class LoadOrderHistory extends CheckoutEvent {
  const LoadOrderHistory();
}

class LoadPaymentMethods extends CheckoutEvent {}

class LoadShippingMethods extends CheckoutEvent {}

class GetOrderDetails extends CheckoutEvent {
  final int orderId;

  const GetOrderDetails(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateShippingInfo extends CheckoutEvent {
  final ShippingInfo shippingInfo;

  const UpdateShippingInfo(this.shippingInfo);

  @override
  List<Object?> get props => [shippingInfo];
}

class SaveShippingInfo extends CheckoutEvent {
  final ShippingInfo shippingInfo;

  const SaveShippingInfo(this.shippingInfo);

  @override
  List<Object?> get props => [shippingInfo];
}

// States
abstract class CheckoutState extends Equatable {
  final String? error;
  final bool isLoading;
  final bool isValid;
  final String? couponCode;
  final BillingInfo? billingInfo;
  final ShippingInfo? shippingInfo;
  final String? shippingMethodId;
  final String? paymentMethodId;
  final String? orderNotes;
  final List<Map<String, dynamic>> paymentMethods;
  final List<Map<String, dynamic>> shippingMethods;

  const CheckoutState({
    this.error,
    this.isLoading = false,
    this.isValid = false,
    this.couponCode,
    this.billingInfo,
    this.shippingInfo,
    this.shippingMethodId,
    this.paymentMethodId,
    this.orderNotes,
    this.paymentMethods = const [],
    this.shippingMethods = const [],
  });

  @override
  List<Object?> get props => [
        error,
        isLoading,
        isValid,
        couponCode,
        billingInfo,
        shippingInfo,
        shippingMethodId,
        paymentMethodId,
        orderNotes,
        paymentMethods,
        shippingMethods,
      ];

  CheckoutState copyWith({
    String? error,
    bool? isLoading,
    bool? isValid,
    String? couponCode,
    BillingInfo? billingInfo,
    ShippingInfo? shippingInfo,
    String? shippingMethodId,
    String? paymentMethodId,
    String? orderNotes,
    List<Map<String, dynamic>>? paymentMethods,
    List<Map<String, dynamic>>? shippingMethods,
  }) {
    return CheckoutInitial(
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      couponCode: couponCode ?? this.couponCode,
      billingInfo: billingInfo ?? this.billingInfo,
      shippingInfo: shippingInfo ?? this.shippingInfo,
      shippingMethodId: shippingMethodId ?? this.shippingMethodId,
      paymentMethodId: paymentMethodId ?? this.paymentMethodId,
      orderNotes: orderNotes ?? this.orderNotes,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      shippingMethods: shippingMethods ?? this.shippingMethods,
    );
  }

  bool validateState() {
    print('Validating state:'); // Debug log
    print('- billingInfo: $billingInfo'); // Debug log
    print('- shippingInfo: $shippingInfo'); // Debug log
    print('- shippingMethodId: $shippingMethodId'); // Debug log
    print('- paymentMethodId: $paymentMethodId'); // Debug log

    // For the checkout form, we only need billing and shipping info
    // Other validations will be done in later steps
    if (billingInfo == null || shippingInfo == null) {
      return false;
    }

    // Ensure all required billing fields have data
    bool hasBillingData = billingInfo!.firstName.isNotEmpty &&
        billingInfo!.lastName.isNotEmpty &&
        billingInfo!.email.isNotEmpty &&
        billingInfo!.phone.isNotEmpty &&
        billingInfo!.address.isNotEmpty &&
        billingInfo!.city.isNotEmpty &&
        billingInfo!.state.isNotEmpty &&
        billingInfo!.zip.isNotEmpty;

    // Ensure all required shipping fields have data
    bool hasShippingData = shippingInfo!.firstName.isNotEmpty &&
        shippingInfo!.lastName.isNotEmpty &&
        shippingInfo!.phone.isNotEmpty &&
        shippingInfo!.address.isNotEmpty &&
        shippingInfo!.city.isNotEmpty &&
        shippingInfo!.state.isNotEmpty &&
        shippingInfo!.zip.isNotEmpty;

    return hasBillingData && hasShippingData;
  }
}

class CheckoutInitial extends CheckoutState {
  const CheckoutInitial({
    super.error,
    super.isLoading = false,
    super.isValid = false,
    super.couponCode,
    super.billingInfo,
    super.shippingInfo,
    super.shippingMethodId,
    super.paymentMethodId,
    super.orderNotes,
    super.paymentMethods,
    super.shippingMethods,
  });
}

class CheckoutLoading extends CheckoutState {
  const CheckoutLoading() : super(isLoading: true);
}

class CheckoutSuccess extends CheckoutState {
  final Map<String, dynamic>? orderDetails;

  const CheckoutSuccess(
    BillingInfo billingInfo, {
    ShippingInfo? shippingInfo,
    this.orderDetails,
  }) : super(
          billingInfo: billingInfo,
          shippingInfo: shippingInfo,
        );

  // Factory method to create a CheckoutSuccess with default shipping from billing
  factory CheckoutSuccess.withDefaultShipping(
    BillingInfo billingInfo, {
    Map<String, dynamic>? orderDetails,
  }) {
    final defaultShipping = ShippingInfo(
      firstName: billingInfo.firstName,
      lastName: billingInfo.lastName,
      phone: billingInfo.phone,
      address: billingInfo.address,
      city: billingInfo.city,
      state: billingInfo.state,
      zip: billingInfo.zip,
    );

    return CheckoutSuccess(
      billingInfo,
      shippingInfo: defaultShipping,
      orderDetails: orderDetails,
    );
  }

  @override
  List<Object?> get props => [...super.props, orderDetails];
}

class CheckoutError extends CheckoutState {
  const CheckoutError(String message) : super(error: message);
}

class OrderHistoryLoading extends CheckoutState {}

class OrderHistoryLoaded extends CheckoutState {
  final List<Order> orders;

  const OrderHistoryLoaded(this.orders);

  @override
  List<Object?> get props => [...super.props, orders];
}

class OrderHistoryError extends CheckoutState {
  const OrderHistoryError(String message) : super(error: message);
}

class OrderDetailsLoading extends CheckoutState {
  const OrderDetailsLoading() : super(isLoading: true);
}

class OrderDetailsLoaded extends CheckoutState {
  final OrderDetails orderDetails;

  const OrderDetailsLoaded(this.orderDetails);

  @override
  List<Object?> get props => [...super.props, orderDetails];
}

class PaymentFailed extends CheckoutState {
  final int orderId;
  final String status;

  const PaymentFailed({
    required this.orderId,
    required this.status,
    super.error,
  });

  @override
  List<Object?> get props => [...super.props, orderId, status];
}

class BillingInfoSaving extends CheckoutState {}

class BillingInfoSaved extends CheckoutState {
  @override
  final BillingInfo billingInfo;

  const BillingInfoSaved(this.billingInfo);

  @override
  List<Object?> get props => [billingInfo];
}

class BillingInfoSaveError extends CheckoutState {
  @override
  final String error;

  const BillingInfoSaveError(this.error);

  @override
  List<Object?> get props => [error];
}

class ShippingInfoUpdating extends CheckoutState {}

class ShippingInfoUpdated extends CheckoutState {
  @override
  final ShippingInfo shippingInfo;

  const ShippingInfoUpdated(this.shippingInfo);

  @override
  List<Object?> get props => [shippingInfo];
}

class ShippingInfoUpdateError extends CheckoutState {
  @override
  final String error;

  const ShippingInfoUpdateError(this.error);

  @override
  List<Object?> get props => [error];
}

// Bloc
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository repository;
  final PaymentRepository paymentRepository;
  final PayHereService payHereService;
  final AuthRepository authRepository;

  CheckoutBloc({
    required this.repository,
    required this.paymentRepository,
    required this.payHereService,
    required this.authRepository,
  }) : super(const CheckoutInitial()) {
    on<LoadBillingInfo>(_onLoadBillingInfo);
    on<SaveBillingInfo>(_onSaveBillingInfo);
    on<UpdateBillingInfo>(_onUpdateBillingInfo);
    on<UpdateShippingMethod>(_onUpdateShippingMethod);
    on<UpdatePaymentMethod>(_onUpdatePaymentMethod);
    on<ApplyCoupon>(_onApplyCoupon);
    on<UpdateOrderNotes>(_onUpdateOrderNotes);
    on<PlaceOrder>(_onPlaceOrder);
    on<LoadOrderHistory>(_onLoadOrderHistory);
    on<LoadPaymentMethods>(_onLoadPaymentMethods);
    on<LoadShippingMethods>(_onLoadShippingMethods);
    on<GetOrderDetails>(_onGetOrderDetails);
    on<UpdateShippingInfo>(_onUpdateShippingInfo);
    on<SaveShippingInfo>(_onSaveShippingInfo);
  }

  Future<void> _onLoadBillingInfo(
    LoadBillingInfo event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(const CheckoutLoading());

      // 1. Try local cache first
      final billingInfo = await repository.getBillingInfo();
      final shippingInfo = await repository.getShippingInfo();

      if (billingInfo != null && shippingInfo != null) {
        emit(CheckoutSuccess(billingInfo, shippingInfo: shippingInfo));
        return;
      }

      // 2. If not found, try backend (if logged in)
      final currentUserResult = await authRepository.getCurrentUser();
      bool foundUserBillingInfo = false;
      ShippingInfo? userShippingInfo;
      await currentUserResult.fold(
        (failure) async => emit(const CheckoutInitial()),
        (user) async {
          try {
            final orders = await repository.getOrders(customerId: user.id);
            if (orders.isNotEmpty) {
              final latestOrder = orders.first;
              userShippingInfo = await repository.getShippingInfo();
              if (userShippingInfo == null) {
                final defaultShipping = ShippingInfo(
                  firstName: latestOrder.billingInfo.firstName,
                  lastName: latestOrder.billingInfo.lastName,
                  phone: latestOrder.billingInfo.phone,
                  address: latestOrder.billingInfo.address,
                  city: latestOrder.billingInfo.city,
                  state: latestOrder.billingInfo.state,
                  zip: latestOrder.billingInfo.zip,
                );
                await repository.saveShippingInfo(defaultShipping);
                userShippingInfo = defaultShipping;
              }
              emit(CheckoutSuccess(
                latestOrder.billingInfo,
                shippingInfo: userShippingInfo,
              ));
              foundUserBillingInfo = true;
            }
          } catch (e) {
            print('Failed to load billing info from orders: $e');
          }
        },
      );
      if (!foundUserBillingInfo) {
        emit(const CheckoutInitial());
      }
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  Future<void> _onSaveBillingInfo(
    SaveBillingInfo event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(BillingInfoSaving());
    try {
      await repository.saveBillingInfo(event.billingInfo);
      emit(BillingInfoSaved(event.billingInfo));
    } catch (e) {
      emit(BillingInfoSaveError(e.toString()));
    }
  }

  void _onUpdateBillingInfo(
    UpdateBillingInfo event,
    Emitter<CheckoutState> emit,
  ) async {
    await repository.saveBillingInfo(event.billingInfo);
    emit(state.copyWith(
      billingInfo: event.billingInfo,
      isValid: _validateState(event.billingInfo),
    ));
  }

  void _onUpdateShippingMethod(
    UpdateShippingMethod event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(
      shippingMethodId: event.methodId,
      isValid: _validateState(state.billingInfo),
    ));
  }

  void _onUpdatePaymentMethod(
    UpdatePaymentMethod event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(
      paymentMethodId: event.methodId,
      isValid: _validateState(state.billingInfo),
    ));
  }

  Future<void> _onApplyCoupon(
    ApplyCoupon event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final isValid = await repository.validateCoupon(event.code);
      if (isValid) {
        emit(state.copyWith(
          couponCode: event.code,
          error: null,
        ));
      } else {
        emit(state.copyWith(
          error: 'Invalid coupon code',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to validate coupon',
      ));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onUpdateOrderNotes(
    UpdateOrderNotes event,
    Emitter<CheckoutState> emit,
  ) {
    emit(state.copyWith(orderNotes: event.notes));
  }

  Future<void> _onPlaceOrder(
    PlaceOrder event,
    Emitter<CheckoutState> emit,
  ) async {
    if (!state.validateState()) {
      emit(state.copyWith(
        error: 'Please fill in all required information',
        isLoading: false,
      ));
      return;
    }

    try {
      emit(state.copyWith(isLoading: true));

      // Get current user ID if logged in
      int? currentUserId;
      final currentUser = await authRepository.getCurrentUser();
      currentUser.fold(
        (failure) => null,
        (user) => currentUserId = user.id,
      );

      // Create the order first
      final order = await repository.createOrder(
        billingInfo: state.billingInfo!,
        shippingInfo: state.shippingInfo,
        shippingMethodId: state.shippingMethodId!,
        paymentMethodId: state.paymentMethodId!,
        couponCode: state.couponCode,
        orderNotes: state.orderNotes,
        customerId: currentUserId,
      );

      // If payment method is PayHere, initiate payment
      if (state.paymentMethodId == 'payhere_payment') {
        try {
          final paymentResponse = await payHereService.initiatePayment(
            orderId: order['id'].toString(),
            amount: double.parse(order['total']),
            customerName:
                '${state.billingInfo!.firstName} ${state.billingInfo!.lastName}',
            customerEmail: state.billingInfo!.email,
            customerPhone: state.billingInfo!.phone,
            currency: 'LKR',
            billingInfo: state.billingInfo!,
            shippingInfo: state.shippingInfo!,
          );

          if (paymentResponse.status == 'SUCCESS') {
            // Update order status after successful payment
            await repository.updateOrderAfterPayment(order['id'].toString());
            emit(CheckoutSuccess(
              state.billingInfo!,
              shippingInfo: state.shippingInfo,
              orderDetails: order,
            ));
          } else if (paymentResponse.status == 'DISMISSED') {
            // User dismissed the payment dialog - keep the order but with pending status
            emit(PaymentFailed(
              orderId: order['id'],
              status: 'cancelled',
              error: 'Payment was cancelled. Your order is saved but not paid.',
            ));
            return;
          } else {
            // Payment failed with error
            final errorMessage =
                paymentResponse.message ?? 'Payment processing failed';

            // Log the detailed error for debugging
            print('Payment failed: ${paymentResponse.message}');
            print('Transaction ID: ${paymentResponse.transactionId}');
            print('Order ID: ${paymentResponse.orderId}');

            // Cancel or mark the order as failed
            await _handleFailedPayment(order['id'].toString(), errorMessage);

            emit(PaymentFailed(
              orderId: order['id'],
              status: 'failed',
              error: 'Payment failed: $errorMessage',
            ));
            return;
          }
        } catch (e) {
          // Handle unexpected payment processing errors
          print('Unexpected payment error: $e');
          await _handleFailedPayment(order['id'].toString(), e.toString());

          emit(PaymentFailed(
            orderId: order['id'],
            status: 'failed',
            error: 'Payment processing failed: ${e.toString()}',
          ));
          return;
        }
      } else {
        // For other payment methods
        emit(CheckoutSuccess(
          state.billingInfo!,
          shippingInfo: state.shippingInfo,
          orderDetails: order,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        error: 'Failed to place order: ${e.toString()}',
        isLoading: false,
      ));
    }
  }

  // Helper method to handle failed payments
  Future<void> _handleFailedPayment(String orderId, String reason) async {
    try {
      // Update the order to indicate payment failed
      await repository.updateOrder(
        orderId: orderId,
        orderData: {
          'status': 'failed',
          'customer_note': 'Payment failed: $reason',
        },
      );
      print('Order $orderId marked as failed due to payment issue');
    } catch (e) {
      print('Failed to update order status after payment failure: $e');
    }
  }

  Future<void> _onLoadOrderHistory(
    LoadOrderHistory event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(OrderHistoryLoading());
    try {
      // Get current user ID if logged in to filter orders
      int? customerId;
      final userResult = await authRepository.getCurrentUser();
      userResult.fold(
        (failure) => null,
        (user) => customerId = user.id,
      );

      final orders = await repository.getOrders(customerId: customerId);
      emit(OrderHistoryLoaded(orders));
    } catch (e) {
      emit(OrderHistoryError(e.toString()));
    }
  }

  Future<void> _onLoadPaymentMethods(
    LoadPaymentMethods event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      print('Loading payment methods...'); // Debug log
      emit(state.copyWith(isLoading: true));
      final methods = await repository.getPaymentMethods();
      print('Payment methods loaded: $methods'); // Debug log
      emit(state.copyWith(
        paymentMethods: methods,
        isLoading: false,
      ));
    } catch (e) {
      print('Error loading payment methods: $e'); // Debug log
      emit(state.copyWith(
        error: 'Failed to load payment methods: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> _onLoadShippingMethods(
    LoadShippingMethods event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      print('Loading shipping methods...'); // Debug log
      // Clear any previous errors when retrying and set loading state
      emit(state.copyWith(
        isLoading: true,
        error: null, // Clear previous errors
      ));

      final methods = await repository.getShippingMethods();
      print('Shipping methods loaded: ${methods.length}'); // Debug log

      // If there are shipping methods, select the first one by default
      if (methods.isNotEmpty && state.shippingMethodId == null) {
        final defaultMethod = methods.first;
        // Make sure the ID is not null or empty
        final methodId = defaultMethod['id']?.toString();
        if (methodId != null && methodId.isNotEmpty) {
          emit(state.copyWith(
            shippingMethodId: methodId,
            shippingMethods: methods,
            isLoading: false,
          ));
        } else {
          // Handle invalid method ID
          emit(state.copyWith(
            shippingMethods: methods,
            isLoading: false,
          ));
        }
      } else {
        emit(state.copyWith(
          shippingMethods: methods,
          isLoading: false,
        ));
      }
    } catch (e) {
      print('Error loading shipping methods: $e'); // Debug log

      // Provide a user-friendly error message
      String errorMessage = 'Unable to load shipping options';
      if (e.toString().contains('NoSuchMethod')) {
        errorMessage =
            'Error processing shipping data. Please try again later.';
      } else if (e.toString().contains('SocketException') ||
          e.toString().contains('Connection')) {
        errorMessage =
            'Network error. Please check your connection and try again.';
      }

      emit(state.copyWith(
        error: errorMessage,
        isLoading: false,
        // Ensure we emit an empty list (not null) to prevent repeated loading attempts
        shippingMethods: const [],
      ));
    }
  }

  Future<void> _onGetOrderDetails(
    GetOrderDetails event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const OrderDetailsLoading());
    try {
      final orderDetails = await repository.getOrderDetails(event.orderId);
      emit(OrderDetailsLoaded(orderDetails));
    } catch (e) {
      emit(CheckoutError('Failed to load order details: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateShippingInfo(
    UpdateShippingInfo event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(ShippingInfoUpdating());
    try {
      await repository.saveShippingInfo(event.shippingInfo);
      emit(ShippingInfoUpdated(event.shippingInfo));
    } catch (e) {
      emit(ShippingInfoUpdateError(e.toString()));
    }
  }

  Future<void> _onSaveShippingInfo(
    SaveShippingInfo event,
    Emitter<CheckoutState> emit,
  ) async {
    try {
      emit(const CheckoutLoading());
      await repository.saveShippingInfo(event.shippingInfo);

      if (state.billingInfo != null) {
        emit(CheckoutSuccess(
          state.billingInfo!,
          shippingInfo: event.shippingInfo,
        ));
      } else {
        // If we don't have billing info yet, just update the shipping info
        emit(state.copyWith(
          shippingInfo: event.shippingInfo,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(CheckoutError(e.toString()));
    }
  }

  bool _validateState(BillingInfo? billingInfo, [ShippingInfo? shippingInfo]) {
    return billingInfo != null &&
        (shippingInfo ?? state.shippingInfo) != null &&
        state.shippingMethodId != null &&
        state.paymentMethodId != null;
  }
}
