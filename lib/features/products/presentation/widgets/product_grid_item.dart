import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/product.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_loading_shimmer.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;

  const ProductGridItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Card(
      elevation: AppDimensions.cardElevation,
      color: isDarkMode ? AppColors.surface : AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CachedNetworkImage(
              imageUrl:
                  product.imageUrls.isNotEmpty ? product.imageUrls.first : '',
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => const AppLoadingShimmer(
                height: double.infinity,
                borderRadius: AppDimensions.borderRadiusNone,
              ),
              errorWidget: (context, url, error) => Container(
                color: isDarkMode ? AppColors.surface : AppColors.background,
                child: const Icon(
                  Icons.error_outline,
                  color: AppColors.error,
                  size: AppDimensions.iconSizeM,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDarkMode
                        ? AppColors.textPrimary
                        : AppColors.textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spacingS),
                CurrencyFormatter.styledPriceText(
                  context,
                  product.price,
                ),
                if (product.categories.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.spacingXS),
                  Text(
                    product.categories.first,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDarkMode
                          ? AppColors.textSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
