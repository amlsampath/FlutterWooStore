import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import 'product_card.dart';
import 'product_card_shimmer.dart';
import '../utils/fly_to_cart_animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce_app/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:ecommerce_app/features/cart/domain/entities/cart_item.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';

class AppProductGrid extends StatelessWidget {
  final List<Product> products;
  final bool isLoading;
  final bool isDarkMode;
  final int crossAxisCount;
  final double childAspectRatio;
  final EdgeInsetsGeometry? padding;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final Widget Function(BuildContext, int)? itemBuilder;
  final int? shimmerCount;
  final GlobalKey cartIconKey;

  const AppProductGrid({
    super.key,
    required this.products,
    this.isLoading = false,
    this.isDarkMode = false,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
    this.padding,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.itemBuilder,
    this.shimmerCount = 6,
    required this.cartIconKey,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding ?? EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing ?? AppDimensions.spacingM,
          mainAxisSpacing: mainAxisSpacing ?? AppDimensions.spacingM,
        ),
        itemCount: shimmerCount,
        itemBuilder: (context, index) => ProductCardShimmer(
          isDarkMode: isDarkMode,
          height: AppDimensions.iconSizeXXL * 2,
          borderRadius: AppDimensions.borderRadiusM,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ?? EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing ?? AppDimensions.spacingM,
        mainAxisSpacing: mainAxisSpacing ?? AppDimensions.spacingM,
      ),
      itemCount: products.length,
      itemBuilder: itemBuilder ??
          (context, index) {
            final product = products[index];
            final imageKey = GlobalKey();
            return ProductCard(
              key: ValueKey(product.id),
              product: product,
              imageKey: imageKey,
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
                    context.read<CartBloc>().add(AddCartItem(cartItem));
                  },
                );
              },
            );
          },
    );
  }
}
