import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/category_constants.dart';
import '../../../products/domain/entities/product.dart';
import '../../../products/domain/repositories/product_repository.dart';

// Events
abstract class NewArrivalsEvent extends Equatable {
  const NewArrivalsEvent();
  @override
  List<Object> get props => [];
}

class LoadNewArrivals extends NewArrivalsEvent {}

// States
abstract class NewArrivalsState extends Equatable {
  const NewArrivalsState();
  @override
  List<Object> get props => [];
}

class NewArrivalsInitial extends NewArrivalsState {}

class NewArrivalsLoading extends NewArrivalsState {}

class NewArrivalsLoaded extends NewArrivalsState {
  final List<Product> products;
  const NewArrivalsLoaded(this.products);
  @override
  List<Object> get props => [products];
}

class NewArrivalsError extends NewArrivalsState {
  final String message;
  const NewArrivalsError(this.message);
  @override
  List<Object> get props => [message];
}

// Bloc
class NewArrivalsBloc extends Bloc<NewArrivalsEvent, NewArrivalsState> {
  final ProductRepository repository;
  NewArrivalsBloc({required this.repository}) : super(NewArrivalsInitial()) {
    on<LoadNewArrivals>(_onLoadNewArrivals);
  }

  Future<void> _onLoadNewArrivals(
    LoadNewArrivals event,
    Emitter<NewArrivalsState> emit,
  ) async {
    emit(NewArrivalsLoading());
    final result = await repository.getProductsByCategory(
      categoryId: CategoryConstants.NEW_ARRIVALS.toString(),
      page: 1,
      perPage: 10,
    );
    result.fold(
      (failure) => emit(NewArrivalsError(failure.toString())),
      (products) => emit(NewArrivalsLoaded(products)),
    );
  }
}
