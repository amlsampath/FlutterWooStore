import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final Function(int) onChanged;
  final int minQuantity;
  final int maxQuantity;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.minQuantity = 1,
    this.maxQuantity = 99,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppColors.surface : AppColors.background;
    final textColor =
        isDarkMode ? AppColors.textPrimary : AppColors.textPrimary;
    final disabledColor =
        isDarkMode ? AppColors.textSecondary : AppColors.textSecondary;

    return Container(
      height: AppDimensions.buttonHeightS,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.border.withOpacity(0.3),
          width: AppDimensions.borderWidthThin,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusCircular),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  quantity > minQuantity ? () => onChanged(quantity - 1) : null,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.borderRadiusCircular),
                bottomLeft: Radius.circular(AppDimensions.borderRadiusCircular),
              ),
              child: SizedBox(
                width: AppDimensions.buttonHeightS,
                height: AppDimensions.buttonHeightS,
                child: Icon(
                  Icons.remove,
                  size: AppDimensions.iconSizeS,
                  color: quantity > minQuantity
                      ? textColor
                      : disabledColor.withOpacity(0.5),
                ),
              ),
            ),
          ),

          // Quantity display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingS),
            alignment: Alignment.center,
            child: Text(
              quantity.toString(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),

          // Plus button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap:
                  quantity < maxQuantity ? () => onChanged(quantity + 1) : null,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppDimensions.borderRadiusCircular),
                bottomRight:
                    Radius.circular(AppDimensions.borderRadiusCircular),
              ),
              child: SizedBox(
                width: AppDimensions.buttonHeightS,
                height: AppDimensions.buttonHeightS,
                child: Icon(
                  Icons.add,
                  size: AppDimensions.iconSizeS,
                  color: quantity < maxQuantity
                      ? textColor
                      : disabledColor.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
