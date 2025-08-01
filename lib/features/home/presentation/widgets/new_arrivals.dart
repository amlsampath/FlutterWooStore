import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/products/presentation/bloc/product_bloc.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../features/favorites/presentation/bloc/favorite_bloc.dart';
import '../../../../features/favorites/domain/entities/favorite_item.dart';
import '../../../../core/widgets/product_card_shimmer.dart';

class NewArrivals extends StatelessWidget {
  const NewArrivals({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return _buildLoadingShimmer(isDarkMode);
        }

        if (state is ProductError) {
          return Center(
              child: Text(state.message, style: TextStyle(color: textColor)));
        }

        if (state is ProductLoaded) {
          // Get newest products by date (assuming newest are at the beginning)
          final newArrivals = state.products.take(5).toList();

          if (newArrivals.isEmpty) {
            return Center(
              child: Text(
                'No new arrivals available',
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
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 170,
                ),
                itemCount: newArrivals.length,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  final product = newArrivals[index];
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

        return const SizedBox();
      },
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 16,
        mainAxisExtent: 170,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return ProductCardShimmer(
            isDarkMode: isDarkMode, height: 130, borderRadius: 12);
      },
    );
  }
}
