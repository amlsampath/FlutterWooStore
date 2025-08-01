import 'package:ecommerce_app/core/widgets/cart_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_app_bar.dart';
import '../../../../core/widgets/app_product_grid.dart';
import '../../../../core/widgets/empty_state_message.dart';
import '../../../../core/widgets/error_state_message.dart';
import '../bloc/category_product_bloc.dart';
import '../../../../core/widgets/bottom_navigation.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  final String? categoryId;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    this.categoryId,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  late final BottomNavigation _bottomNavigation;

  @override
  void initState() {
    super.initState();
    _bottomNavigation = BottomNavigation();
    // Do not dispatch bloc event here
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppAppBar(
        title: widget.categoryName,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: AppDimensions.iconSizeM,
              color: theme.colorScheme.onSurface,
            ),
            onPressed: () => context.push('/search'),
          ),
          const CartIconButton(),
        ],
      ),
      body: BlocConsumer<CategoryProductBloc, CategoryProductState>(
        listener: (context, state) {
          if (state is CategoryProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryProductInitial && widget.categoryId != null) {
            context
                .read<CategoryProductBloc>()
                .add(LoadCategoryProducts(widget.categoryId!));
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CategoryProductInitial ||
              state is CategoryProductLoading) {
            return AppProductGrid(
              products: const [],
              isLoading: true,
              isDarkMode: isDark,
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spacingM,
                AppDimensions.spacingM,
                AppDimensions.spacingM,
                kBottomNavigationBarHeight + AppDimensions.spacingM,
              ),
              cartIconKey: _bottomNavigation.cartIconKey,
            );
          }

          if (state is CategoryProductError) {
            return ErrorStateMessage(
              message: 'Error loading products: ${state.message}',
              icon: Icons.error_outline,
              onRetryPressed: widget.categoryId != null
                  ? () => context
                      .read<CategoryProductBloc>()
                      .add(LoadCategoryProducts(widget.categoryId!))
                  : null,
            );
          }

          if (state is CategoryProductLoaded) {
            final products = state.products;
            if (products.isEmpty) {
              return const EmptyStateMessage(
                message: 'No products found in this category',
                icon: Icons.category_outlined,
                actionLabel: 'Browse All Categories',
                onActionPressed: null,
              );
            }
            return AppProductGrid(
              products: products,
              isDarkMode: isDark,
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              cartIconKey: _bottomNavigation.cartIconKey,
            );
          }

          return const SizedBox();
        },
      ),
      bottomNavigationBar: _bottomNavigation,
    );
  }
}
