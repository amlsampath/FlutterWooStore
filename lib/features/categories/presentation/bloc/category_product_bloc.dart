import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/repositories/product_repository.dart';

// Events
abstract class CategoryProductEvent extends Equatable {
  const CategoryProductEvent();
  @override
  List<Object> get props => [];
}

class LoadCategoryProducts extends CategoryProductEvent {
  final String categoryId;
  const LoadCategoryProducts(this.categoryId);
  @override
  List<Object> get props => [categoryId];
}

// States
abstract class CategoryProductState extends Equatable {
  const CategoryProductState();
  @override
  List<Object> get props => [];
}

class CategoryProductInitial extends CategoryProductState {}

class CategoryProductLoading extends CategoryProductState {}

class CategoryProductLoaded extends CategoryProductState {
  final List<Product> products;
  final String categoryId;
  const CategoryProductLoaded(
      {required this.products, required this.categoryId});
  @override
  List<Object> get props => [products, categoryId];
}

class CategoryProductError extends CategoryProductState {
  final String message;
  const CategoryProductError(this.message);
  @override
  List<Object> get props => [message];
}

class CategoryProductBloc
    extends Bloc<CategoryProductEvent, CategoryProductState> {
  final ProductRepository repository;
  CategoryProductBloc({required this.repository})
      : super(CategoryProductInitial()) {
    on<LoadCategoryProducts>(_onLoadCategoryProducts);
  }

  Future<void> _onLoadCategoryProducts(
    LoadCategoryProducts event,
    Emitter<CategoryProductState> emit,
  ) async {
    emit(CategoryProductLoading());
    final result = await repository.getProductsByCategory(
      categoryId: event.categoryId,
      page: 1,
      perPage: 20,
    );
    result.fold(
      (failure) => emit(CategoryProductError(failure.toString())),
      (products) => emit(CategoryProductLoaded(
          products: products, categoryId: event.categoryId)),
    );
  }
}
