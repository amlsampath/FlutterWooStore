import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import '../utils/currency_formatter.dart';
import '../../features/cart/domain/entities/cart_item.dart';

class OrderItemCard extends StatelessWidget {
  final CartItem item;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const OrderItemCard({
    super.key,
    required this.item,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: margin ?? const EdgeInsets.only(bottom: AppDimensions.spacingS),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(AppDimensions.spacingM),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
              child: Image.network(
                item.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Size: ${item.selectedSize ?? 'XL'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    'Qty: ${item.quantity}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CurrencyFormatter.styledPriceText(
              context,
              item.price,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
