import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppSizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSizeSelected;
  final double size;
  final double spacing;
  final Color? selectedColor;
  final Color? selectedTextColor;
  final Color? unselectedColor;
  final Color? unselectedTextColor;
  final double borderRadius;
  final TextStyle? textStyle;

  const AppSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSizeSelected,
    this.size = 40,
    this.spacing = 8,
    this.selectedColor,
    this.selectedTextColor,
    this.unselectedColor,
    this.unselectedTextColor,
    this.borderRadius = 8,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final defaultSelectedColor = selectedColor ?? AppColors.primary;
    final defaultSelectedTextColor = selectedTextColor ?? AppColors.textPrimary;
    final defaultUnselectedColor =
        unselectedColor ?? (isDarkMode ? AppColors.surface : AppColors.surface);
    final defaultUnselectedTextColor =
        unselectedTextColor ?? AppColors.textPrimary;

    return Wrap(
      spacing: spacing,
      children: sizes.map((size) {
        final isSelected = selectedSize == size;
        return GestureDetector(
          onTap: () => onSizeSelected(size),
          child: Container(
            width: this.size,
            height: this.size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? defaultSelectedColor : defaultUnselectedColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Text(
              size,
              style: (textStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                color: isSelected
                    ? defaultSelectedTextColor
                    : defaultUnselectedTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
