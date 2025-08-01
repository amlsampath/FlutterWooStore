import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/repositories/cart_repository.dart';

// Events
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCart extends CartEvent {}

class AddCartItem extends CartEvent {
  final CartItem item;
  const AddCartItem(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveCartItem extends CartEvent {
  final int productId;
  const RemoveCartItem(this.productId);
  @override
  List<Object?> get props => [productId];
}

class ToggleCartItemSelection extends CartEvent {
  final int productId;
  const ToggleCartItemSelection(this.productId);
  @override
  List<Object?> get props => [productId];
}

class ToggleSelectAll extends CartEvent {
  final bool selectAll;
  const ToggleSelectAll(this.selectAll);
  @override
  List<Object?> get props => [selectAll];
}

class RemoveSelectedCartItems extends CartEvent {
  const RemoveSelectedCartItems();
}

// States
abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final double shipping;
  final double total;
  final Set<int> selectedProductIds;

  const CartLoaded({
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.shipping,
    required this.total,
    this.selectedProductIds = const {},
  });

  CartLoaded copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? tax,
    double? discount,
    double? shipping,
    double? total,
    Set<int>? selectedProductIds,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      shipping: shipping ?? this.shipping,
      total: total ?? this.total,
      selectedProductIds: selectedProductIds ?? this.selectedProductIds,
    );
  }

  @override
  List<Object?> get props =>
      [items, subtotal, tax, discount, shipping, total, selectedProductIds];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}

// Constants
const double kCartTaxRate = 0.0; // No tax in cart summary
const double kCartShippingFee = 0.0; // No shipping in cart summary
const double kCartDiscount = 0.0; // Default discount

// Bloc
class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc(this.repository) : super(CartLoading()) {
    on<LoadCart>(_onLoadCart);
    on<AddCartItem>(_onAddCartItem);
    on<RemoveCartItem>(_onRemoveCartItem);
    on<ToggleCartItemSelection>(_onToggleCartItemSelection);
    on<ToggleSelectAll>(_onToggleSelectAll);
    on<RemoveSelectedCartItems>(_onRemoveSelectedCartItems);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    try {
      final items = await repository.getCartItems();
      final subtotal = items.fold(
          0.0, (sum, item) => sum + (double.parse(item.price) * item.quantity));
      emit(CartLoaded(
        items: items,
        subtotal: subtotal,
        tax: subtotal * kCartTaxRate,
        discount: kCartDiscount,
        shipping: kCartShippingFee,
        total: subtotal - kCartDiscount,
        selectedProductIds: const {},
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onAddCartItem(
      AddCartItem event, Emitter<CartState> emit) async {
    try {
      await repository.addCartItem(event.item);
      final items = await repository.getCartItems();
      final subtotal = items.fold(
          0.0, (sum, item) => sum + (double.parse(item.price) * item.quantity));
      emit(CartLoaded(
        items: items,
        subtotal: subtotal,
        tax: subtotal * kCartTaxRate,
        discount: kCartDiscount,
        shipping: kCartShippingFee,
        total: subtotal - kCartDiscount,
        selectedProductIds: const {},
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveCartItem(
      RemoveCartItem event, Emitter<CartState> emit) async {
    try {
      await repository.removeCartItem(event.productId);
      final items = await repository.getCartItems();
      final subtotal = items.fold(
          0.0, (sum, item) => sum + (double.parse(item.price) * item.quantity));
      emit(CartLoaded(
        items: items,
        subtotal: subtotal,
        tax: subtotal * kCartTaxRate,
        discount: kCartDiscount,
        shipping: kCartShippingFee,
        total: subtotal - kCartDiscount,
        selectedProductIds: const {},
      ));
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  void _onToggleCartItemSelection(
      ToggleCartItemSelection event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartLoaded) {
      final selected = Set<int>.from(state.selectedProductIds);
      if (selected.contains(event.productId)) {
        selected.remove(event.productId);
      } else {
        selected.add(event.productId);
      }
      emit(state.copyWith(selectedProductIds: selected));
    }
  }

  void _onToggleSelectAll(ToggleSelectAll event, Emitter<CartState> emit) {
    final state = this.state;
    if (state is CartLoaded) {
      if (event.selectAll) {
        final allIds = state.items.map((e) => e.productId).toSet();
        emit(state.copyWith(selectedProductIds: allIds));
      } else {
        emit(state.copyWith(selectedProductIds: {}));
      }
    }
  }

  Future<void> _onRemoveSelectedCartItems(
      RemoveSelectedCartItems event, Emitter<CartState> emit) async {
    final state = this.state;
    if (state is CartLoaded && state.selectedProductIds.isNotEmpty) {
      await repository.removeCartItems(state.selectedProductIds.toList());
      final items = await repository.getCartItems();
      final subtotal = items.fold(
          0.0, (sum, item) => sum + (double.parse(item.price) * item.quantity));
      emit(CartLoaded(
        items: items,
        subtotal: subtotal,
        tax: subtotal * kCartTaxRate,
        discount: kCartDiscount,
        shipping: kCartShippingFee,
        total: subtotal - kCartDiscount,
        selectedProductIds: const {},
      ));
    }
  }
}
