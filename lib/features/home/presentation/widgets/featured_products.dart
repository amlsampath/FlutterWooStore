import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/products/presentation/bloc/product_bloc.dart';
import '../../../../features/products/domain/entities/product.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../features/favorites/presentation/bloc/favorite_bloc.dart';
import '../../../../features/favorites/domain/entities/favorite_item.dart';
import '../../../../core/widgets/product_card_shimmer.dart';

class FeaturedProducts extends StatefulWidget {
  const FeaturedProducts({super.key});

  @override
  State<FeaturedProducts> createState() => _FeaturedProductsState();
}

class _FeaturedProductsState extends State<FeaturedProducts> {
  @override
  void initState() {
    super.initState();
    // Load products if not already loaded
    final productState = context.read<ProductBloc>().state;
    if (productState is! ProductLoaded) {
      context.read<ProductBloc>().add(const LoadProducts());
    }

    // Load favorites
    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  List<Product> _getFeaturedProducts(List<Product> products) {
    // TODO: Implement proper featured products logic
    // For now, we'll take the first 5 products with the highest price as featured
    return List<Product>.from(products)
      ..sort((a, b) {
        final priceA =
            double.tryParse(a.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
        final priceB =
            double.tryParse(b.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 0;
        return priceB.compareTo(priceA);
      })
      ..take(5);
  }

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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading products',
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: () {
                    context.read<ProductBloc>().add(const LoadProducts());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ProductLoaded) {
          final featuredProducts = _getFeaturedProducts(state.products);

          if (featuredProducts.isEmpty) {
            return Center(
              child: Text(
                'No featured products available',
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
                itemCount: featuredProducts.length,
                itemBuilder: (context, index) {
                  final product = featuredProducts[index];
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
