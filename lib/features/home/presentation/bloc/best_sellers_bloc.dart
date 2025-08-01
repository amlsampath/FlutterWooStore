import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/category_constants.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/repositories/product_repository.dart';

// Events
abstract class BestSellersEvent extends Equatable {
  const BestSellersEvent();
  @override
  List<Object> get props => [];
}

class LoadBestSellers extends BestSellersEvent {}

// States
abstract class BestSellersState extends Equatable {
  const BestSellersState();
  @override
  List<Object> get props => [];
}

class BestSellersInitial extends BestSellersState {}

class BestSellersLoading extends BestSellersState {}

class BestSellersLoaded extends BestSellersState {
  final List<Product> products;
  const BestSellersLoaded(this.products);
  @override
  List<Object> get props => [products];
}

class BestSellersError extends BestSellersState {
  final String message;
  const BestSellersError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class BestSellersBloc extends Bloc<BestSellersEvent, BestSellersState> {
  final ProductRepository repository;
  BestSellersBloc({required this.repository}) : super(BestSellersInitial()) {
    on<LoadBestSellers>(_onLoadBestSellers);
  }

  Future<void> _onLoadBestSellers(
    LoadBestSellers event,
    Emitter<BestSellersState> emit,
  ) async {
    emit(BestSellersLoading());
    final result = await repository.getProductsByCategory(
      categoryId: CategoryConstants.BEST_SELLERS.toString(),
      page: 1,
      perPage: 10,
    );
    result.fold(
      (failure) => emit(BestSellersError(failure.toString())),
      (products) => emit(BestSellersLoaded(products)),
    );
  }
}
