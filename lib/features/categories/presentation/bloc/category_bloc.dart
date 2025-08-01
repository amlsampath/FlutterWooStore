import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';

// Events
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class SelectCategory extends CategoryEvent {
  final Category? category;

  const SelectCategory(this.category);

  @override
  List<Object?> get props => [category];
}

// States
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}

class CategoriesLoaded extends CategoryState {
  final List<Category> categories;
  final Category? selectedCategory;

  const CategoriesLoaded({
    required this.categories,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [categories, selectedCategory];

  CategoriesLoaded copyWith({
    List<Category>? categories,
    Category? selectedCategory,
  }) {
    return CategoriesLoaded(
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory,
    );
  }
}

// Bloc
class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc({required this.repository}) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<SelectCategory>(_onSelectCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    final result = await repository.getCategories();
    await result.fold(
      (failure) async => emit(CategoryError(failure.toString())),
      (categories) async => emit(CategoriesLoaded(categories: categories)),
    );
  }

  void _onSelectCategory(SelectCategory event, Emitter<CategoryState> emit) {
    if (state is CategoriesLoaded) {
      final currentState = state as CategoriesLoaded;
      emit(currentState.copyWith(selectedCategory: event.category));
    }
  }
}
