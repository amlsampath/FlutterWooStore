import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/currency_formatter.dart';
import '../../features/cart/domain/entities/cart_item.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';

class AppCartItemRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onDelete;
  final bool selected;
  final ValueChanged<bool?>? onSelectedChanged;
  final double? imageSize;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? shadowColor;
  final double? shadowOpacity;
  final double? borderRadius;
  final bool showQuantityControls;
  final bool showDeleteButton;
  final Function(int)? onQuantityChanged;

  const AppCartItemRow({
    Key? key,
    required this.item,
    required this.onDelete,
    this.selected = false,
    this.onSelectedChanged,
    this.imageSize = 80,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.shadowColor,
    this.shadowOpacity,
    this.borderRadius,
    this.showQuantityControls = true,
    this.showDeleteButton = true,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: AppDimensions.spacingM),
      padding: padding ?? AppDimensions.cardPadding,
      decoration: BoxDecoration(
        //  color: AppColors.primary,
        borderRadius: BorderRadius.circular(borderRadius ?? 16),
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: AppColors.imageBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: imageSize,
                  height: imageSize,
                  color: theme.dividerColor,
                  child: Icon(Icons.broken_image, color: theme.iconTheme.color),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    //height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDimensions.spacingXS),
                if (item.selectedSize != null || item.selectedColor != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingS,
                      vertical: AppDimensions.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadiusXS),
                    ),
                    child: Text(
                      'Size: ${item.selectedSize ?? 'N/A'} • Color: ${item.selectedColor ?? 'N/A'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                const SizedBox(height: AppDimensions.spacingS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.formatPrice(item.price),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    if (showQuantityControls)
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.counterBackground,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.counterBorder),
                        ),
                        child: Row(
                          children: [
                            _counterButton(Icons.remove, () {
                              if (item.quantity > 1) {
                                if (onQuantityChanged != null) {
                                  onQuantityChanged!(item.quantity - 1);
                                } else {
                                  context.read<CartBloc>().add(
                                        AddCartItem(
                                          item.copyWith(
                                              quantity: item.quantity - 1),
                                        ),
                                      );
                                }
                              } else {
                                onDelete();
                              }
                            }),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                item.quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            _counterButton(Icons.add, () {
                              if (onQuantityChanged != null) {
                                onQuantityChanged!(item.quantity + 1);
                              } else {
                                context.read<CartBloc>().add(
                                      AddCartItem(
                                        item.copyWith(
                                            quantity: item.quantity + 1),
                                      ),
                                    );
                              }
                            }),
                          ],
                        ),
                      ),
                    if (showDeleteButton)
                      IconButton(
                        icon:
                            const Icon(Icons.delete_outline, color: AppColors.error),
                        tooltip: 'Remove from cart',
                        onPressed: onDelete,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _counterButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.counterButton,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
