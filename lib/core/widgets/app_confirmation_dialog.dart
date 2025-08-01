import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../utils/currency_formatter.dart';
import '../../features/cart/domain/entities/cart_item.dart';
import '../theme/app_theme_extension.dart';
import 'app_elevated_button.dart';
import 'app_text_button.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;
  final Color? cancelColor;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.confirmColor,
    this.cancelColor,
    this.icon,
    this.iconColor,
    this.onConfirm,
    this.onCancel,
  });

  /// Factory constructor for cart item removal confirmation
  factory AppConfirmationDialog.removeCartItem({
    required CartItem item,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return AppConfirmationDialog(
      title: 'Remove from Cart?',
      message: 'Are you sure you want to remove this item from your cart?',
      confirmLabel: 'Remove',
      confirmColor: AppColors.error,
      icon: Icons.delete_outline,
      iconColor: AppColors.error,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? theme.colorScheme.primary,
            ),
            const SizedBox(width: AppDimensions.spacingS),
          ],
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        AppTextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
          text: cancelLabel,
          textColor: cancelColor,
        ),
        AppElevatedButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          text: confirmLabel,
          backgroundColor: confirmColor,
        ),
      ],
    );
  }
}

class _CartItemPreview extends StatelessWidget {
  final CartItem item;

  const _CartItemPreview({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusS),
            child: Container(
              width: 60,
              height: 60,
              color: theme.colorScheme.surface,
              child: Image.network(
                item.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
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
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.selectedSize != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: AppDimensions.spacingXS,
                    ),
                    child: Text(
                      'Size: ${item.selectedSize}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                      ),
                    ),
                  ),
                const SizedBox(height: AppDimensions.spacingXS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      CurrencyFormatter.formatPrice(item.price),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingS,
                        vertical: AppDimensions.spacingXXS,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.borderRadiusCircular,
                        ),
                      ),
                      child: Text(
                        'Qty: ${item.quantity}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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
}
