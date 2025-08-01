import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shipping_info.dart';
import '../../domain/repositories/checkout_repository.dart';

// Events
abstract class ShippingAddressEvent {}

class LoadShippingAddress extends ShippingAddressEvent {}

class SaveShippingAddress extends ShippingAddressEvent {
  final ShippingInfo shippingInfo;
  SaveShippingAddress(this.shippingInfo);
}

class UpdateShippingAddress extends ShippingAddressEvent {
  final ShippingInfo shippingInfo;
  UpdateShippingAddress(this.shippingInfo);
}

// States
abstract class ShippingAddressState {}

class ShippingAddressInitial extends ShippingAddressState {}

class ShippingAddressLoading extends ShippingAddressState {}

class ShippingAddressLoaded extends ShippingAddressState {
  final ShippingInfo shippingInfo;
  ShippingAddressLoaded(this.shippingInfo);
}

class ShippingAddressSuccess extends ShippingAddressState {
  final ShippingInfo shippingInfo;
  final String message;
  ShippingAddressSuccess(this.shippingInfo, this.message);
}

class ShippingAddressError extends ShippingAddressState {
  final String message;
  ShippingAddressError(this.message);
}

// Bloc
class ShippingAddressBloc
    extends Bloc<ShippingAddressEvent, ShippingAddressState> {
  final CheckoutRepository repository;

  ShippingAddressBloc({required this.repository})
      : super(ShippingAddressInitial()) {
    on<LoadShippingAddress>((event, emit) async {
      emit(ShippingAddressLoading());
      try {
        final shippingInfo = await repository.getShippingInfo();
        if (shippingInfo != null) {
          emit(ShippingAddressLoaded(shippingInfo));
        } else {
          emit(ShippingAddressError('No shipping address found.'));
        }
      } catch (e) {
        emit(ShippingAddressError('Failed to load shipping address: $e'));
      }
    });

    on<SaveShippingAddress>((event, emit) async {
      emit(ShippingAddressLoading());
      try {
        await repository.saveShippingInfo(event.shippingInfo);
        emit(ShippingAddressSuccess(
            event.shippingInfo, 'Shipping address saved successfully!'));
      } catch (e) {
        emit(ShippingAddressError('Failed to save shipping address: $e'));
      }
    });

    on<UpdateShippingAddress>((event, emit) async {
      emit(ShippingAddressLoading());
      try {
        await repository.saveShippingInfo(event.shippingInfo);
        emit(ShippingAddressSuccess(
            event.shippingInfo, 'Shipping address updated successfully!'));
      } catch (e) {
        emit(ShippingAddressError('Failed to update shipping address: $e'));
      }
    });
  }
}
