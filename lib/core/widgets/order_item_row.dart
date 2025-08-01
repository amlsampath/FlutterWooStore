import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import '../utils/currency_formatter.dart';

class OrderItemRow extends StatelessWidget {
  final String name;
  final int quantity;
  final String total;
  final String? imageUrl;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const OrderItemRow({
    super.key,
    required this.name,
    required this.quantity,
    required this.total,
    this.imageUrl,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: AppDimensions.spacingS),
      padding: padding ??
          const EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
      child: Row(
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
              child: Image.network(
                imageUrl!,
                width: AppDimensions.iconSizeL,
                height: AppDimensions.iconSizeL,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: AppDimensions.iconSizeL,
                  height: AppDimensions.iconSizeL,
                  color: theme.colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.image,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          if (imageUrl != null) const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Quantity: $quantity',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          CurrencyFormatter.styledPriceText(
            context,
            total,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
