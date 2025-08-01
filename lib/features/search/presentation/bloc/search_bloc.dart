import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../products/domain/repositories/product_repository.dart';
import '../../data/datasources/product_search_local_data_source.dart';
import '../../../../core/error/failures.dart';

// Events
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchProducts extends SearchEvent {
  final String query;
  final bool loadMore;

  const SearchProducts({
    required this.query,
    this.loadMore = false,
  });

  @override
  List<Object> get props => [query, loadMore];
}

class ClearSearch extends SearchEvent {}

// States
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  final List<dynamic> currentResults;
  final bool isFirstFetch;

  const SearchLoading({
    this.currentResults = const [],
    this.isFirstFetch = false,
  });

  @override
  List<Object> get props => [currentResults, isFirstFetch];
}

class SearchResults extends SearchState {
  final List<dynamic> products;

  const SearchResults(this.products);

  @override
  List<Object> get props => [products];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ProductRepository productRepository;
  final ProductSearchLocalDataSource localDataSource;
  static const int _productsPerPage = 10;

  SearchBloc({
    required this.productRepository,
    required this.localDataSource,
  }) : super(SearchInitial()) {
    on<SearchProducts>(_onSearchProducts);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<SearchState> emit,
  ) async {
    try {
      if (event.loadMore) {
        if (state is SearchLoading) return;
        final currentState = state as SearchResults;
        emit(SearchLoading(currentResults: currentState.products));
      } else {
        emit(const SearchLoading(isFirstFetch: true));
      }

      final result = await productRepository.searchProducts(
        query: event.query.isEmpty ? '' : event.query,
        page: 1,
        perPage: event.query.isEmpty ? 100 : _productsPerPage,
      );

      await result.fold(
        (failure) async => emit(SearchError(_mapFailureToMessage(failure))),
        (products) async {
          final productsJson = products
              .map((product) => {
                    'id': product.id,
                    'name': product.name,
                    'description': product.description,
                    'images': [
                      {
                        'src': product.imageUrls.isNotEmpty
                            ? product.imageUrls[0]
                            : ''
                      }
                    ],
                    'price': product.price,
                    'categories': [
                      {
                        'name': product.categories.isNotEmpty
                            ? product.categories[0]
                            : ''
                      }
                    ],
                  })
              .toList();

          await localDataSource.saveProducts(productsJson);
          if (event.query.isEmpty) {
            emit(SearchInitial());
          } else {
            emit(SearchResults(products));
          }
        },
      );
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred';
      case CacheFailure:
        return 'Cache error occurred';
      default:
        return 'Unexpected error occurred';
    }
  }
}
