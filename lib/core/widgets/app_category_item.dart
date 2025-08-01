import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_theme_extension.dart';

class AppCategoryItem extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback onTap;
  final IconData? fallbackIcon;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;

  const AppCategoryItem({
    super.key,
    required this.name,
    this.imageUrl,
    required this.onTap,
    this.fallbackIcon,
    this.backgroundColor,
    this.iconColor,
    this.size = 60,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;
    final isDarkMode = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        margin: const EdgeInsets.only(right: AppDimensions.spacingM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: backgroundColor ??
                    _getCategoryColor(name, isDarkMode, theme),
                shape: BoxShape.circle,
                boxShadow: appTheme.elevationShadow1,
              ),
              child: ClipOval(
                child: imageUrl != null
                    ? Image.network(
                        imageUrl!,
                        width: size,
                        height: size,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            fallbackIcon ?? _getCategoryIcon(name),
                            color: iconColor ?? theme.colorScheme.onSurface,
                            size: iconSize,
                          );
                        },
                      )
                    : Icon(
                        fallbackIcon ?? _getCategoryIcon(name),
                        color: iconColor ?? theme.colorScheme.onSurface,
                        size: iconSize,
                      ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(
      String categoryName, bool isDarkMode, ThemeData theme) {
    if (isDarkMode) {
      switch (categoryName.toLowerCase()) {
        case 'accessories':
          return theme.colorScheme.primary.withOpacity(0.8);
        case 'clocks':
          return theme.colorScheme.secondary.withOpacity(0.8);
        case 'cooking':
          return theme.colorScheme.error.withOpacity(0.8);
        case 'furniture':
          return theme.colorScheme.tertiary.withOpacity(0.8);
        case 'lights':
          return theme.colorScheme.primaryContainer.withOpacity(0.8);
        default:
          return theme.colorScheme.surfaceContainerHighest;
      }
    } else {
      switch (categoryName.toLowerCase()) {
        case 'accessories':
          return theme.colorScheme.primary.withOpacity(0.1);
        case 'clocks':
          return theme.colorScheme.secondary.withOpacity(0.1);
        case 'cooking':
          return theme.colorScheme.error.withOpacity(0.1);
        case 'furniture':
          return theme.colorScheme.tertiary.withOpacity(0.1);
        case 'lights':
          return theme.colorScheme.primaryContainer.withOpacity(0.1);
        default:
          return theme.colorScheme.surfaceContainerHighest;
      }
    }
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'accessories':
        return Icons.watch;
      case 'clocks':
        return Icons.access_time;
      case 'cooking':
        return Icons.restaurant_menu;
      case 'furniture':
        return Icons.chair;
      case 'lights':
        return Icons.lightbulb_outline;
      default:
        return Icons.category;
    }
  }
}
