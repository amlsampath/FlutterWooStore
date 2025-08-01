import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onAction;
  final String? actionLabel;
  final Color? iconColor;
  final Color? textColor;
  final double iconSize;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const AppEmptyState({
    super.key,
    required this.message,
    this.icon,
    this.onAction,
    this.actionLabel,
    this.iconColor,
    this.textColor,
    this.iconSize = 64,
    this.spacing = 16,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultIconColor = iconColor ?? theme.colorScheme.onSurfaceVariant;
    final defaultTextColor = textColor ?? theme.colorScheme.onSurfaceVariant;

    Widget content = Padding(
      padding: padding ?? const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(
              icon,
              size: iconSize,
              color: defaultIconColor,
            ),
          if (icon != null) SizedBox(height: spacing),
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: defaultTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (onAction != null && actionLabel != null) ...[
            SizedBox(height: spacing),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );

    if (margin != null) {
      content = Container(margin: margin, child: content);
    }

    return Center(child: content);
  }
}
