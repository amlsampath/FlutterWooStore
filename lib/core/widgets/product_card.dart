import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/products/domain/entities/product.dart';
import '../utils/currency_formatter.dart';
import '../theme/app_dimensions.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Function()? onFavoritePressed;
  final Function()? onAddToCart;
  final void Function(GlobalKey imageKey, Product product)?
      onAddToCartWithAnimation;
  final bool isFavorite;
  final bool showFavoriteButton;
  final double? height;
  final double? width;
  final GlobalKey? imageKey;

  const ProductCard({
    Key? key,
    required this.product,
    this.onFavoritePressed,
    this.onAddToCart,
    this.onAddToCartWithAnimation,
    this.isFavorite = false,
    this.showFavoriteButton = true,
    this.height,
    this.width,
    this.imageKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black87;
    final GlobalKey effectiveImageKey = imageKey ?? GlobalKey();

    return GestureDetector(
      onTap: () {
        context.push('/product/${product.id}', extra: product);
            },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xFF0A0A0A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: isDarkMode
                  ? Colors.black.withOpacity(0.4)
                  : Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 10),
              blurRadius: 30,
              spreadRadius: -5,
            ),
          ],
        ),
        child: SizedBox(
          height: 220,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AspectRatio(
                      aspectRatio: AppDimensions.productCardImageAspectRatio,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  product.imageUrls.isNotEmpty
                                      ? product.imageUrls.first
                                      : 'https://placehold.co/600x400/png',
                                  key: effectiveImageKey,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: isDarkMode
                                          ? const Color(0xFF1A1A1A)
                                          : Colors.grey.shade200,
                                      child: Center(
                                        child: Icon(
                                          Icons.image_not_supported_outlined,
                                          color: isDarkMode
                                              ? Colors.grey.shade600
                                              : Colors.grey.shade400,
                                          size: 32,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Positioned.fill(
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.2),
                                        ],
                                        stops: const [0.7, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (showFavoriteButton)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: onFavoritePressed,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.black.withOpacity(0.5)
                                        : Colors.white.withOpacity(0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isFavorite
                                        ? Colors.red
                                        : Colors.grey[400],
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    CurrencyFormatter.formatPrice(
                                        product.price),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              if (onAddToCartWithAnimation != null) {
                                onAddToCartWithAnimation!(
                                    effectiveImageKey, product);
                              } else if (onAddToCart != null) {
                                onAddToCart!();
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isDarkMode
                                            ? Colors.orange
                                            : Colors.deepOrange)
                                        .withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
