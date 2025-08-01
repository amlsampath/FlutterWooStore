import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/billing_info.dart';
import '../../domain/repositories/checkout_repository.dart';

// Events
abstract class BillingAddressEvent {}

class LoadBillingAddress extends BillingAddressEvent {}

class SaveBillingAddress extends BillingAddressEvent {
  final BillingInfo billingInfo;
  SaveBillingAddress(this.billingInfo);
}

class UpdateBillingAddress extends BillingAddressEvent {
  final BillingInfo billingInfo;
  UpdateBillingAddress(this.billingInfo);
}

// States
abstract class BillingAddressState {}

class BillingAddressInitial extends BillingAddressState {}

class BillingAddressLoading extends BillingAddressState {}

class BillingAddressLoaded extends BillingAddressState {
  final BillingInfo billingInfo;
  BillingAddressLoaded(this.billingInfo);
}

class BillingAddressSuccess extends BillingAddressState {
  final BillingInfo billingInfo;
  final String message;
  BillingAddressSuccess(this.billingInfo, this.message);
}

class BillingAddressError extends BillingAddressState {
  final String message;
  BillingAddressError(this.message);
}

// Bloc
class BillingAddressBloc
    extends Bloc<BillingAddressEvent, BillingAddressState> {
  final CheckoutRepository repository;

  BillingAddressBloc({required this.repository})
      : super(BillingAddressInitial()) {
    on<LoadBillingAddress>((event, emit) async {
      emit(BillingAddressLoading());
      try {
        final billingInfo = await repository.getBillingInfo();
        if (billingInfo != null) {
          emit(BillingAddressLoaded(billingInfo));
        } else {
          emit(BillingAddressError('No billing address found.'));
        }
      } catch (e) {
        emit(BillingAddressError('Failed to load billing address: $e'));
      }
    });

    on<SaveBillingAddress>((event, emit) async {
      emit(BillingAddressLoading());
      try {
        await repository.saveBillingInfo(event.billingInfo);
        emit(BillingAddressSuccess(
            event.billingInfo, 'Billing info saved successfully!'));
      } catch (e) {
        emit(BillingAddressError('Failed to save billing address: $e'));
      }
    });

    on<UpdateBillingAddress>((event, emit) async {
      emit(BillingAddressLoading());
      try {
        await repository.saveBillingInfo(event.billingInfo);
        emit(BillingAddressSuccess(
            event.billingInfo, 'Billing info updated successfully!'));
      } catch (e) {
        emit(BillingAddressError('Failed to update billing address: $e'));
      }
    });
  }
}
