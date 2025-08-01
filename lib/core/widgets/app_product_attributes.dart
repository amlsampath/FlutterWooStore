import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AppProductAttributes extends StatelessWidget {
  final List<String> attributes;
  final List<String> excludeAttributes;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const AppProductAttributes({
    super.key,
    required this.attributes,
    this.excludeAttributes = const [],
    this.titleStyle,
    this.valueStyle,
    this.backgroundColor,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.all(16),
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final defaultBackgroundColor =
        backgroundColor ?? (isDarkMode ? AppColors.surface : AppColors.surface);

    final filteredAttributes = attributes.where((attr) {
      final lowerAttr = attr.toLowerCase();
      return !excludeAttributes
          .any((exclude) => lowerAttr.contains(exclude.toLowerCase()));
    }).toList();

    if (filteredAttributes.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: filteredAttributes.map((attribute) {
          final parts = attribute.split(':');
          if (parts.length < 2) return const SizedBox.shrink();

          final title = parts[0].trim();
          final value = parts[1].trim();

          return Padding(
            padding: EdgeInsets.only(bottom: spacing),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: (titleStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: (valueStyle ?? theme.textTheme.bodyMedium)?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
