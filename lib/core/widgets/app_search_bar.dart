import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? textColor;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final Color? shadowColor;
  final double? shadowOpacity;
  final TextEditingController? controller;
  final List<Widget>? trailing;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const AppSearchBar({
    super.key,
    this.hintText = 'Search...',
    this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.borderRadius = 32,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.elevation = 2,
    this.shadowColor,
    this.shadowOpacity,
    this.controller,
    this.trailing,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final defaultBackgroundColor =
        backgroundColor ?? (isDarkMode ? Colors.grey[800] : Colors.white);
    final defaultIconColor = iconColor ?? theme.colorScheme.onSurfaceVariant;
    final defaultTextColor =
        textColor ?? theme.colorScheme.onSurfaceVariant.withOpacity(0.7);
    final defaultShadowColor = shadowColor ?? AppColors.shadow;
    final defaultShadowOpacity = shadowOpacity ?? 0.05;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: defaultBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: defaultShadowColor.withOpacity(defaultShadowOpacity),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: defaultIconColor,
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: defaultTextColor,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                color: defaultTextColor,
              ),
            ),
          ),
          if (trailing != null) ...trailing!,
        ],
      ),
    );
  }
}

class AppHeaderSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;

  const AppHeaderSearchBar({
    super.key,
    this.hintText = 'Search product',
    this.onSearchTap,
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, left: 16, right: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onSearchTap,
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white70),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hintText,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: Colors.white70),
              onPressed: onFilterTap,
              splashRadius: 24,
            ),
          ),
        ],
      ),
    );
  }
}
