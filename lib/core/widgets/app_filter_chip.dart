import 'package:flutter/material.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isLoading;
  final Color? selectedColor;
  final Color? backgroundColor;
  final Color? labelColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppFilterChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.isLoading = false,
    this.selectedColor,
    this.backgroundColor,
    this.labelColor,
    this.borderRadius = 20,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultSelectedColor = selectedColor ?? theme.colorScheme.primary;
    final defaultBackgroundColor = backgroundColor ?? theme.colorScheme.surface;
    final defaultLabelColor = labelColor ?? theme.colorScheme.onSurface;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        margin: margin,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? defaultSelectedColor : defaultBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color:
                isSelected ? defaultSelectedColor : theme.colorScheme.outline,
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: defaultSelectedColor.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isSelected ? Colors.white : defaultSelectedColor,
                  ),
                ),
              )
            else
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isSelected ? Colors.white : defaultLabelColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
