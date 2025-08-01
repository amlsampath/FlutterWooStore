import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';

class CartItemCard extends StatelessWidget {
  final CartItem item;

  const CartItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      child: Padding(
        padding: AppDimensions.cardPadding,
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
              child: Image.network(
                item.imageUrl,
                width: AppDimensions.iconSizeXXL,
                height: AppDimensions.iconSizeXXL,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: AppDimensions.iconSizeXXL,
                  height: AppDimensions.iconSizeXXL,
                  color: theme.dividerColor,
                  child: Icon(
                    Icons.broken_image,
                    color: theme.iconTheme.color,
                    size: AppDimensions.iconSizeM,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingXS),

                  // Display the price
                  CurrencyFormatter.styledPriceText(
                    context,
                    item.price,
                    fontSize: theme.textTheme.titleMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),

                  // Display selected attributes
                  if (item.selectedSize != null || item.selectedColor != null)
                    const SizedBox(height: AppDimensions.spacingXS),

                  // Display selected size if available
                  if (item.selectedSize != null)
                    Text(
                      'Size: ${item.selectedSize}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),

                  // Display selected color if available
                  if (item.selectedColor != null)
                    Text(
                      'Color: ${item.selectedColor}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.secondary,
                      ),
                    ),

                  // Display other attributes if available
                  if (item.additionalAttributes != null &&
                      item.additionalAttributes!.isNotEmpty)
                    ...item.additionalAttributes!.entries.map(
                      (entry) => Text(
                        '${entry.key.substring(0, 1).toUpperCase()}${entry.key.substring(1)}: ${entry.value}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Quantity Controls
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.remove_circle_outline,
                    size: AppDimensions.iconSizeM,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    if (item.quantity > 1) {
                      context.read<CartBloc>().add(
                            AddCartItem(
                              item.copyWith(quantity: item.quantity - 1),
                            ),
                          );
                    } else {
                      context.read<CartBloc>().add(
                            RemoveCartItem(item.productId),
                          );
                    }
                  },
                ),
                Text(
                  item.quantity.toString(),
                  style: theme.textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: AppDimensions.iconSizeM,
                    color: theme.colorScheme.primary,
                  ),
                  onPressed: () {
                    context.read<CartBloc>().add(
                          AddCartItem(
                            item.copyWith(quantity: item.quantity + 1),
                          ),
                        );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
