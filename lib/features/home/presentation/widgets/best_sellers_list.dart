import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/best_sellers_bloc.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../features/favorites/presentation/bloc/favorite_bloc.dart';
import '../../../../features/favorites/domain/entities/favorite_item.dart';
import '../../../../core/widgets/product_card_shimmer.dart';
import 'section_title.dart';
import 'package:ecommerce_app/core/utils/fly_to_cart_animation.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';

class BestSellersList extends StatelessWidget {
  final GlobalKey cartIconKey;
  const BestSellersList({super.key, required this.cartIconKey});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return BlocBuilder<BestSellersBloc, BestSellersState>(
      builder: (context, state) {
        if (state is BestSellersInitial) {
          context.read<BestSellersBloc>().add(LoadBestSellers());
          return const SizedBox.shrink();
        }
        if (state is BestSellersLoading) {
          return _buildLoadingShimmer(isDarkMode);
        }
        if (state is BestSellersError) {
          return Center(
            child: Text(state.message, style: TextStyle(color: textColor)),
          );
        }
        if (state is BestSellersLoaded) {
          final products = state.products;
          if (products.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Best Sellers',
                actionText: 'See all',
                onActionPressed: () => context.push('/best-sellers'),
              ),
              BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, favoriteState) {
                  final favoriteProductIds = favoriteState is FavoritesLoaded
                      ? favoriteState.items.map((f) => f.productId).toList()
                      : <int>[];
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: products.length > 10 ? 10 : products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final isFavorite =
                          favoriteProductIds.contains(product.id);
                      final imageKey = GlobalKey();
                      return ProductCard(
                        product: product,
                        isFavorite: isFavorite,
                        imageKey: imageKey,
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
                        onAddToCartWithAnimation: (key, product) {
                          FlyToCartAnimation.animate(
                            context: context,
                            imageKey: imageKey,
                            cartIconKey: cartIconKey,
                            product: product,
                            onComplete: () {
                              final cartItem = CartItem(
                                productId: product.id,
                                name: product.name,
                                imageUrl: product.imageUrls.first,
                                price: product.price,
                                quantity: 1,
                              );
                              context
                                  .read<CartBloc>()
                                  .add(AddCartItem(cartItem));
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: 'Best Sellers',
          actionText: 'See all',
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
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
        ),
      ],
    );
  }
}
