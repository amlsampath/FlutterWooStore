import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../features/products/presentation/bloc/product_bloc.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../features/favorites/presentation/bloc/favorite_bloc.dart';
import '../../../../features/favorites/domain/entities/favorite_item.dart';
import '../../../../core/widgets/product_card_shimmer.dart';
import 'section_title.dart';

class CategoryProductsList extends StatefulWidget {
  final int categoryId;
  final String sectionTitle;
  final String actionText;
  final VoidCallback? onActionPressed;

  const CategoryProductsList({
    super.key,
    required this.categoryId,
    required this.sectionTitle,
    required this.actionText,
    this.onActionPressed,
  });

  @override
  State<CategoryProductsList> createState() => _CategoryProductsListState();
}

class _CategoryProductsListState extends State<CategoryProductsList> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(
          LoadProductsByCategory(widget.categoryId.toString()),
        );
    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          title: widget.sectionTitle,
          actionText: widget.actionText,
          onActionPressed: widget.onActionPressed,
        ),
        SizedBox(
          height: 200,
          width: double.infinity,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return _buildLoadingShimmer(isDarkMode);
                  }
                  if (state is ProductError) {
                    return Center(
                      child: Text(state.message,
                          style: TextStyle(color: textColor)),
                    );
                  }
                  if (state is CategoryProductsLoaded &&
                      state.categoryId == widget.categoryId.toString()) {
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
                        final favoriteProductIds =
                            favoriteState is FavoritesLoaded
                                ? favoriteState.items
                                    .map((f) => f.productId)
                                    .toList()
                                : <int>[];
                        return SizedBox(
                          width: constraints.maxWidth,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                products.length > 5 ? 5 : products.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final product = products[index];
                              final isFavorite =
                                  favoriteProductIds.contains(product.id);
                              return SizedBox(
                                width: 180,
                                child: ProductCard(
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
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox();
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingShimmer(bool isDarkMode) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        return SizedBox(
          width: 180,
          child: ProductCardShimmer(
            isDarkMode: isDarkMode,
            height: 130,
            borderRadius: 12,
          ),
        );
      },
    );
  }
}
