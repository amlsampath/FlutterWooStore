import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/category_constants.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/repositories/product_repository.dart';

// Events
abstract class TrendingNowEvent extends Equatable {
  const TrendingNowEvent();
  @override
  List<Object> get props => [];
}

class LoadTrendingNow extends TrendingNowEvent {}

// States
abstract class TrendingNowState extends Equatable {
  const TrendingNowState();
  @override
  List<Object> get props => [];
}

class TrendingNowInitial extends TrendingNowState {}

class TrendingNowLoading extends TrendingNowState {}

class TrendingNowLoaded extends TrendingNowState {
  final List<Product> products;
  const TrendingNowLoaded(this.products);
  @override
  List<Object> get props => [products];
}

class TrendingNowError extends TrendingNowState {
  final String message;
  const TrendingNowError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class TrendingNowBloc extends Bloc<TrendingNowEvent, TrendingNowState> {
  final ProductRepository repository;
  TrendingNowBloc({required this.repository}) : super(TrendingNowInitial()) {
    on<LoadTrendingNow>(_onLoadTrendingNow);
  }

  Future<void> _onLoadTrendingNow(
    LoadTrendingNow event,
    Emitter<TrendingNowState> emit,
  ) async {
    emit(TrendingNowLoading());
    final result = await repository.getProductsByCategory(
      categoryId: CategoryConstants.TRENDING_NOW.toString(),
      page: 1,
      perPage: 10,
    );
    result.fold(
      (failure) => emit(TrendingNowError(failure.toString())),
      (products) => emit(TrendingNowLoaded(products)),
    );
  }
}
