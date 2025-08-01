import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_item.dart';
import '../../domain/repositories/favorite_repository.dart';

// Events
abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class AddFavorite extends FavoriteEvent {
  final FavoriteItem item;
  const AddFavorite(this.item);
  @override
  List<Object?> get props => [item];
}

class RemoveFavorite extends FavoriteEvent {
  final int productId;
  const RemoveFavorite(this.productId);
  @override
  List<Object?> get props => [productId];
}

class CheckFavorite extends FavoriteEvent {
  final int productId;
  const CheckFavorite(this.productId);
  @override
  List<Object?> get props => [productId];
}

class ClearAllFavorites extends FavoriteEvent {}

// States
abstract class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object?> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoritesLoaded extends FavoriteState {
  final List<FavoriteItem> items;
  final Map<int, bool> favoriteStatus;

  const FavoritesLoaded({
    required this.items,
    this.favoriteStatus = const {},
  });

  @override
  List<Object?> get props => [items, favoriteStatus];

  FavoritesLoaded copyWith({
    List<FavoriteItem>? items,
    Map<int, bool>? favoriteStatus,
  }) {
    return FavoritesLoaded(
      items: items ?? this.items,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
    );
  }
}

class FavoriteError extends FavoriteState {
  final String message;
  const FavoriteError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  FavoriteBloc(this.repository) : super(FavoriteLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavorite>(_onAddFavorite);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<CheckFavorite>(_onCheckFavorite);
    on<ClearAllFavorites>(_onClearAllFavorites);
  }

  Future<void> _onLoadFavorites(
      LoadFavorites event, Emitter<FavoriteState> emit) async {
    try {
      final items = await repository.getFavorites();
      final favoriteStatus = {for (var item in items) item.productId: true};
      emit(FavoritesLoaded(items: items, favoriteStatus: favoriteStatus));
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> _onAddFavorite(
      AddFavorite event, Emitter<FavoriteState> emit) async {
    try {
      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        await repository.addFavorite(event.item);
        final items = await repository.getFavorites();
        emit(currentState.copyWith(
          items: items,
          favoriteStatus: {
            ...currentState.favoriteStatus,
            event.item.productId: true
          },
        ));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> _onRemoveFavorite(
      RemoveFavorite event, Emitter<FavoriteState> emit) async {
    try {
      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        await repository.removeFavorite(event.productId);
        final items = await repository.getFavorites();
        emit(currentState.copyWith(
          items: items,
          favoriteStatus: {...currentState.favoriteStatus}
            ..remove(event.productId),
        ));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> _onCheckFavorite(
      CheckFavorite event, Emitter<FavoriteState> emit) async {
    try {
      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        final isFavorite = await repository.isFavorite(event.productId);
        emit(currentState.copyWith(
          favoriteStatus: {
            ...currentState.favoriteStatus,
            event.productId: isFavorite
          },
        ));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  Future<void> _onClearAllFavorites(
      ClearAllFavorites event, Emitter<FavoriteState> emit) async {
    try {
      if (state is FavoritesLoaded) {
        final currentState = state as FavoritesLoaded;
        // Clear all favorites from the repository
        for (final item in currentState.items) {
          await repository.removeFavorite(item.productId);
        }
        // Emit empty state
        emit(const FavoritesLoaded(items: [], favoriteStatus: {}));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}
