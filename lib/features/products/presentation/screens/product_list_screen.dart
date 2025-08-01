import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_search_bar.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_shimmer.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../features/categories/presentation/bloc/category_bloc.dart';
import '../../../../features/categories/domain/repositories/category_repository.dart';
import '../../../../features/categories/presentation/widgets/category_list.dart';
import '../../../../features/favorites/presentation/bloc/favorite_bloc.dart';
import '../../../../features/favorites/domain/entities/favorite_item.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../../../../core/widgets/app_header.dart';
import '../../../../core/widgets/product_card.dart';
import '../../../../core/widgets/bottom_navigation.dart';
import 'package:ecommerce_app/core/utils/fly_to_cart_animation.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  late final BottomNavigation _bottomNavigation;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<FavoriteBloc>().add(LoadFavorites());
    _bottomNavigation = BottomNavigation();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const threshold = 200.0;

    if (maxScroll - currentScroll <= threshold) {
      final state = context.read<ProductBloc>().state;
      if (state is ProductLoaded && !state.hasReachedMax) {
        setState(() => _isLoadingMore = true);
        context.read<ProductBloc>().add(const LoadProducts(loadMore: true));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CartAppBar(
      //   title: 'Products',
      // ),
      body: Column(
        children: [
          AppHeader(
            title: 'Products',
            widget: AppHeaderSearchBar(
              hintText: 'Search products...',
              onSearchTap: () => context.push('/search'),
            ),
          ),
          Expanded(
            child: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state is ProductLoaded) {
                  setState(() => _isLoadingMore = false);
                }
              },
              builder: (context, state) {
                if (state is ProductInitial) {
                  context.read<ProductBloc>().add(const LoadProducts());
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductLoading && state.isFirstFetch) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Category loading shimmer
                        const AppLoadingShimmerList(
                          itemCount: 5,
                          itemHeight: 50,
                          itemWidth: 80,
                          spacing: 8,
                          padding: EdgeInsets.symmetric(vertical: 8),
                          direction: Axis.horizontal,
                          borderRadius: 32,
                        ),
                        // Product grid loading shimmer
                        Expanded(
                          child: GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                            itemCount: 6,
                            itemBuilder: (context, index) {
                              return const AppLoadingShimmer(
                                height: 240,
                                borderRadius: 12,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is ProductError) {
                  return AppErrorState(
                    message: state.message,
                    onRetry: () {
                      context.read<ProductBloc>().add(const LoadProducts());
                    },
                  );
                }

                List<Product> products = [];
                bool hasReachedMax = false;

                if (state is ProductLoading) {
                  products = state.currentProducts;
                } else if (state is ProductLoaded) {
                  products = state.products;
                  hasReachedMax = state.hasReachedMax;
                }

                return BlocProvider(
                  create: (context) =>
                      CategoryBloc(repository: GetIt.I<CategoryRepository>())
                        ..add(LoadCategories()),
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, categoryState) {
                      final filteredProducts =
                          categoryState is CategoriesLoaded &&
                                  categoryState.selectedCategory != null
                              ? products
                                  .where((product) => product.categories
                                      .contains(categoryState.selectedCategory))
                                  .toList()
                              : products;

                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            const CategoryList(),
                            Expanded(
                              child: BlocBuilder<FavoriteBloc, FavoriteState>(
                                builder: (context, favoriteState) {
                                  final favoriteProductIds =
                                      favoriteState is FavoritesLoaded
                                          ? favoriteState.items
                                              .map((item) => item.productId)
                                              .toSet()
                                          : <String>{};

                                  if (filteredProducts.isEmpty) {
                                    return AppEmptyState(
                                      message: 'No products found',
                                      icon: Icons.shopping_bag_outlined,
                                      actionLabel: 'Refresh',
                                      onAction: () {
                                        context
                                            .read<ProductBloc>()
                                            .add(const LoadProducts());
                                      },
                                    );
                                  }

                                  return GridView.builder(
                                    controller: _scrollController,
                                    padding: const EdgeInsets.all(0),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: 0.75,
                                    ),
                                    itemCount: filteredProducts.length,
                                    itemBuilder: (context, index) {
                                      final product = filteredProducts[index];
                                      final isFavorite = favoriteProductIds
                                          .contains(product.id);
                                      final imageKey = GlobalKey();
                                      return ProductCard(
                                        product: product,
                                        isFavorite: isFavorite,
                                        imageKey: imageKey,
                                        onFavoritePressed: () {
                                          if (isFavorite) {
                                            context.read<FavoriteBloc>().add(
                                                RemoveFavorite(product.id));
                                          } else {
                                            final favoriteItem = FavoriteItem(
                                              productId: product.id,
                                              name: product.name,
                                              imageUrl:
                                                  product.imageUrls.isNotEmpty
                                                      ? product.imageUrls.first
                                                      : '',
                                              price: product.price,
                                            );
                                            context
                                                .read<FavoriteBloc>()
                                                .add(AddFavorite(favoriteItem));
                                          }
                                        },
                                        onAddToCartWithAnimation:
                                            (key, product) {
                                          FlyToCartAnimation.animate(
                                            context: context,
                                            imageKey: imageKey,
                                            cartIconKey:
                                                _bottomNavigation.cartIconKey,
                                            product: product,
                                            onComplete: () {
                                              final cartItem = CartItem(
                                                productId: product.id,
                                                name: product.name,
                                                imageUrl:
                                                    product.imageUrls.first,
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
                            ),
                            if (_isLoadingMore)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: CircularProgressIndicator(),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNavigation,
    );
  }
}
