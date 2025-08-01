import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class AppEmptyView extends StatelessWidget {
  final String message;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;

  const AppEmptyView({
    super.key,
    required this.message,
    this.icon,
    this.iconColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? theme.colorScheme.onSurface.withOpacity(0.6),
              size: 48,
            ),
            const SizedBox(height: AppDimensions.spacingM),
          ],
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: textColor ?? theme.colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
