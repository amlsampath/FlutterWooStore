import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/shipping_zone.dart';
import '../../domain/repositories/shipping_repository.dart';

// Events
abstract class ShippingEvent extends Equatable {
  const ShippingEvent();

  @override
  List<Object?> get props => [];
}

class LoadShippingZones extends ShippingEvent {}

class SelectShippingMethod extends ShippingEvent {
  final ShippingMethod method;
  final ShippingZone zone;

  const SelectShippingMethod({
    required this.method,
    required this.zone,
  });

  @override
  List<Object?> get props => [method, zone];
}

// States
abstract class ShippingState extends Equatable {
  final List<ShippingZone> zones;
  final ShippingZone? selectedZone;
  final ShippingMethod? selectedMethod;
  final String? error;
  final bool isLoading;

  const ShippingState({
    this.zones = const [],
    this.selectedZone,
    this.selectedMethod,
    this.error,
    this.isLoading = false,
  });

  @override
  List<Object?> get props =>
      [zones, selectedZone, selectedMethod, error, isLoading];
}

class ShippingInitial extends ShippingState {
  const ShippingInitial() : super();
}

class ShippingLoading extends ShippingState {
  final ShippingZone? previousSelectedZone;
  final ShippingMethod? previousSelectedMethod;

  const ShippingLoading({
    this.previousSelectedZone,
    this.previousSelectedMethod,
  }) : super(
          isLoading: true,
          selectedZone: previousSelectedZone,
          selectedMethod: previousSelectedMethod,
        );
}

class ShippingLoaded extends ShippingState {
  const ShippingLoaded({
    required List<ShippingZone> zones,
    ShippingZone? selectedZone,
    ShippingMethod? selectedMethod,
  }) : super(
          zones: zones,
          selectedZone: selectedZone,
          selectedMethod: selectedMethod,
        );
}

class ShippingError extends ShippingState {
  const ShippingError(String message) : super(error: message);
}

// Bloc
class ShippingBloc extends Bloc<ShippingEvent, ShippingState> {
  final ShippingRepository repository;

  ShippingBloc({required this.repository}) : super(const ShippingInitial()) {
    on<LoadShippingZones>(_onLoadShippingZones);
    on<SelectShippingMethod>(_onSelectShippingMethod);
  }

  Future<void> _onLoadShippingZones(
    LoadShippingZones event,
    Emitter<ShippingState> emit,
  ) async {
    // Preserve the selected shipping method while loading
    emit(ShippingLoading(
      previousSelectedZone: state.selectedZone,
      previousSelectedMethod: state.selectedMethod,
    ));

    final result = await repository.getShippingZones();
    result.fold(
      (failure) => emit(ShippingError(failure.toString())),
      (zones) {
        // If we had a previously selected method, try to find and select it again
        if (state.selectedMethod != null && state.selectedZone != null) {
          final updatedZones = zones.map((zone) {
            if (zone.id == state.selectedZone!.id) {
              final method = zone.methods.firstWhere(
                (m) => m.id == state.selectedMethod!.id,
                orElse: () => state.selectedMethod!,
              );
              return ShippingZone(
                id: zone.id,
                name: zone.name,
                order: zone.order,
                locations: zone.locations,
                methods: zone.methods,
              );
            }
            return zone;
          }).toList();

          emit(ShippingLoaded(
            zones: updatedZones,
            selectedZone: state.selectedZone,
            selectedMethod: state.selectedMethod,
          ));
        } else {
          emit(ShippingLoaded(zones: zones));
        }
      },
    );
  }

  void _onSelectShippingMethod(
    SelectShippingMethod event,
    Emitter<ShippingState> emit,
  ) {
    if (state is ShippingLoaded) {
      emit(ShippingLoaded(
        zones: state.zones,
        selectedZone: event.zone,
        selectedMethod: event.method,
      ));
    }
  }
}
