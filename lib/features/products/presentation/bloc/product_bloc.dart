import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

// Events
abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductEvent {
  final bool loadMore;

  const LoadProducts({this.loadMore = false});

  @override
  List<Object> get props => [loadMore];
}

class LoadProductsByCategory extends ProductEvent {
  final String categoryId;

  const LoadProductsByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

// States
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final List<Product> currentProducts;
  final bool isFirstFetch;

  const ProductLoading({
    this.currentProducts = const [],
    this.isFirstFetch = true,
  });

  @override
  List<Object> get props => [currentProducts, isFirstFetch];
}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final bool hasReachedMax;
  final int currentPage;

  const ProductLoaded({
    required this.products,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  ProductLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object> get props => [products, hasReachedMax, currentPage];
}

class CategoryProductsLoaded extends ProductState {
  final List<Product> products;
  final String categoryId;

  const CategoryProductsLoaded({
    required this.products,
    required this.categoryId,
  });

  @override
  List<Object> get props => [products, categoryId];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;
  static const int _productsPerPage = 10;

  ProductBloc({required this.repository}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    if (state is ProductLoaded) {
      final currentState = state as ProductLoaded;
      if (currentState.hasReachedMax && event.loadMore) {
        return;
      }

      if (event.loadMore) {
        emit(ProductLoading(
          currentProducts: currentState.products,
          isFirstFetch: false,
        ));

        final nextPage = currentState.currentPage + 1;
        final result = await repository.getProducts(
          page: nextPage,
          perPage: _productsPerPage,
        );

        await result.fold(
          (failure) async => emit(ProductError(failure.toString())),
          (newProducts) async {
            if (newProducts.isEmpty) {
              emit(currentState.copyWith(hasReachedMax: true));
            } else {
              emit(ProductLoaded(
                products: [...currentState.products, ...newProducts],
                currentPage: nextPage,
                hasReachedMax: newProducts.length < _productsPerPage,
              ));
            }
          },
        );
      }
    } else {
      emit(const ProductLoading());
      final result = await repository.getProducts(
        page: 1,
        perPage: _productsPerPage,
      );

      await result.fold(
        (failure) async => emit(ProductError(failure.toString())),
        (products) async {
          emit(ProductLoaded(
            products: products,
            hasReachedMax: products.length < _productsPerPage,
          ));
        },
      );
    }
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    print('Loading products for category with ID: ${event.categoryId}');

    emit(const ProductLoading());

    try {
      final result = await repository.getProductsByCategory(
        categoryId: event.categoryId,
        page: 1,
        perPage: 20, // Show more products for a category page
      );

      print('API Result for category ${event.categoryId}: $result');

      result.fold(
        (failure) {
          print('Error loading products by category: ${failure.toString()}');
          emit(ProductError(failure.toString()));
        },
        (products) {
          print(
              'Successfully loaded ${products.length} products for category ${event.categoryId}');
          emit(CategoryProductsLoaded(
            products: products,
            categoryId: event.categoryId,
          ));
        },
      );
    } catch (e) {
      print('Exception in _onLoadProductsByCategory: $e');
      emit(ProductError(e.toString()));
    }
  }
}
