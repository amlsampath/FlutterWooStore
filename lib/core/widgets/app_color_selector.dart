import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppColorSelector extends StatelessWidget {
  final Map<String, String> colors;
  final String? selectedColor;
  final ValueChanged<String> onColorSelected;
  final double size;
  final double spacing;
  final double borderWidth;
  final Color? selectedBorderColor;
  final Color? shadowColor;
  final double? shadowOpacity;
  final double? shadowBlur;

  const AppColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
    this.size = 30,
    this.spacing = 16,
    this.borderWidth = 2,
    this.selectedBorderColor,
    this.shadowColor,
    this.shadowOpacity,
    this.shadowBlur,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final defaultSelectedBorderColor = selectedBorderColor ?? AppColors.primary;
    final defaultShadowColor = shadowColor ?? AppColors.shadow;
    final defaultShadowOpacity = shadowOpacity ?? (isDarkMode ? 0.3 : 0.1);
    final defaultShadowBlur = shadowBlur ?? 4.0;

    return Wrap(
      spacing: spacing,
      children: colors.entries.map((entry) {
        final colorName = entry.key;
        final colorCode = entry.value;
        final isSelected = selectedColor == colorName;

        Color colorValue;
        try {
          if (colorCode.isNotEmpty && colorCode.startsWith('#')) {
            colorValue = Color(int.parse('0xFF${colorCode.substring(1)}'));
          } else {
            colorValue = _getColorFromName(colorName, isDarkMode);
          }
        } catch (e) {
          colorValue = AppColors.textSecondary;
        }

        return GestureDetector(
          onTap: () => onColorSelected(colorName),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: colorValue,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? defaultSelectedBorderColor
                    : Colors.transparent,
                width: borderWidth,
              ),
              boxShadow: [
                BoxShadow(
                  color: defaultShadowColor.withOpacity(defaultShadowOpacity),
                  blurRadius: defaultShadowBlur,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColorFromName(String colorName, bool isDarkMode) {
    switch (colorName.toLowerCase()) {
      case 'black':
        return AppColors.textPrimary;
      case 'white':
        return AppColors.surface;
      case 'red':
        return AppColors.error;
      case 'blue':
        return AppColors.info;
      case 'green':
        return AppColors.success;
      case 'yellow':
        return AppColors.warning;
      case 'brown':
        return const Color(0xFF8B4513);
      case 'grey':
      case 'gray':
        return AppColors.textSecondary;
      case 'beige':
        return const Color(0xFFF5F5DC);
      default:
        return AppColors.textSecondary;
    }
  }
}
