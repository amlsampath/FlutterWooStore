import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class EmptyStateMessage extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onActionPressed;
  final String? actionLabel;

  const EmptyStateMessage({
    super.key,
    required this.message,
    this.icon,
    this.onActionPressed,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: AppDimensions.iconSizeXXL,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(height: AppDimensions.spacingM),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (onActionPressed != null && actionLabel != null) ...[
              const SizedBox(height: AppDimensions.spacingM),
              TextButton(
                onPressed: onActionPressed,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
