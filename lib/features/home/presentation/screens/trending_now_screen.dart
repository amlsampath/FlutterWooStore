import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/cart_icon_button.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../features/favorites/presentation/bloc/favorite_bloc.dart';
import '../../../../features/favorites/domain/entities/favorite_item.dart';
import '../../../../core/widgets/product_card_shimmer.dart';
import '../bloc/trending_now_bloc.dart';

class TrendingNowScreen extends StatelessWidget {
  const TrendingNowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: const AppAppBar(
        title: 'Trending Now',
        actions: [CartIconButton()],
      ),
      body: BlocBuilder<TrendingNowBloc, TrendingNowState>(
        builder: (context, state) {
          if (state is TrendingNowLoading) {
            return _buildLoadingShimmer(isDarkMode);
          }
          if (state is TrendingNowError) {
            return Center(
              child: Text(state.message, style: TextStyle(color: textColor)),
            );
          }
          if (state is TrendingNowLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return Center(
                child: Text(
                  'No products available',
                  style: TextStyle(color: textColor),
                ),
              );
            }
            return BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, favoriteState) {
                final favoriteProductIds = favoriteState is FavoritesLoaded
                    ? favoriteState.items.map((f) => f.productId).toList()
                    : <int>[];
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final isFavorite = favoriteProductIds.contains(product.id);
                    return ProductCard(
                      product: product,
                      isFavorite: isFavorite,
                      onFavoritePressed: () {
                        if (isFavorite) {
                          context
                              .read<FavoriteBloc>()
                              .add(RemoveFavorite(product.id));
                        } else {
                          final favoriteItem = FavoriteItem(
                            productId: product.id,
                            name: product.name,
                            imageUrl: product.imageUrls.isNotEmpty
                                ? product.imageUrls.first
                                : '',
                            price: product.price,
                          );
                          context
                              .read<FavoriteBloc>()
                              .add(AddFavorite(favoriteItem));
                        }
                      },
                    );
                  },
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ProductCardShimmer(
          isDarkMode: isDarkMode,
          height: 200,
          borderRadius: 12,
        );
      },
    );
  }
}
