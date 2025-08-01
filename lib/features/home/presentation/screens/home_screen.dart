import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/core/widgets/app_product_grid.dart';
import 'package:ecommerce_app/core/widgets/bottom_navigation.dart';
import 'package:ecommerce_app/features/products/presentation/bloc/product_bloc.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import '../../../../features/categories/presentation/widgets/category_list.dart';
import 'package:go_router/go_router.dart';
import '../widgets/best_sellers_list.dart';
import '../widgets/new_arrivals_list.dart';
import '../widgets/trending_now_list.dart';
import '../bloc/best_sellers_bloc.dart';
import '../bloc/new_arrivals_bloc.dart';
import '../bloc/trending_now_bloc.dart';
import '../widgets/hero_section.dart';
import '../../../../features/categories/presentation/bloc/category_bloc.dart';
import 'package:ecommerce_app/core/theme/app_assets.dart';
import '../widgets/promotion_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final BottomNavigation _bottomNavigation;

  @override
  void initState() {
    super.initState();
    _bottomNavigation = BottomNavigation();
    context.read<CartBloc>().add(LoadCart());
    context.read<ProductBloc>().add(const LoadProducts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Section
            HeroSection(
              title: 'HEADSETS',
              subtitle: 'WIRED | WIRELESS',
              buttonText: 'SHOP NOW',
              imagePath: 'assets/images/headset.png',
              onButtonPressed: () => context.push('/products'),
              onSearchTap: () => context.push('/search'),
              onFilterTap: () => context.push('/search'),
            ),
            // Main Content
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                children: [
                  // Categories
                  BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoryInitial) {
                        context.read<CategoryBloc>().add(LoadCategories());
                        return const SizedBox.shrink();
                      }
                      return const CategoryList();
                    },
                  ),
                  const SizedBox(height: 16),
                  // Best Sellers
                  BlocBuilder<BestSellersBloc, BestSellersState>(
                    builder: (context, state) {
                      if (state is BestSellersInitial) {
                        context.read<BestSellersBloc>().add(LoadBestSellers());
                        return const SizedBox.shrink();
                      }
                      return BestSellersList(
                          cartIconKey: _bottomNavigation.cartIconKey);
                    },
                  ),
                  const SizedBox(height: 16),
                  // New Arrivals
                  BlocBuilder<NewArrivalsBloc, NewArrivalsState>(
                    builder: (context, state) {
                      if (state is NewArrivalsInitial) {
                        context.read<NewArrivalsBloc>().add(LoadNewArrivals());
                        return const SizedBox.shrink();
                      }
                      return NewArrivalsList(
                          cartIconKey: _bottomNavigation.cartIconKey);
                    },
                  ),
                  // Promotion Banner
                  if (AppAssets.homeBanner.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    PromotionBanner.image(
                      imagePath: AppAssets.homeBanner,
                      onTap: () {},
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Trending Now
                  BlocBuilder<TrendingNowBloc, TrendingNowState>(
                    builder: (context, state) {
                      if (state is TrendingNowInitial) {
                        context.read<TrendingNowBloc>().add(LoadTrendingNow());
                        return const SizedBox.shrink();
                      }
                      return TrendingNowList(
                          cartIconKey: _bottomNavigation.cartIconKey);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Main Product Grid
                  BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is ProductError) {
                        return Center(child: Text(state.message));
                      }
                      if (state is ProductLoaded) {
                        return AppProductGrid(
                          products: state.products,
                          isLoading: false,
                          cartIconKey: _bottomNavigation.cartIconKey,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNavigation,
    );
  }

  String _getInitials(String firstName, String lastName) {
    return firstName.isNotEmpty && lastName.isNotEmpty
        ? '${firstName[0]}${lastName[0]}'
        : firstName.isNotEmpty
            ? firstName[0]
            : '?';
  }
}
