import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class ErrorStateMessage extends StatelessWidget {
  final String message;
  final IconData? icon;
  final VoidCallback? onRetryPressed;
  final String? retryLabel;

  const ErrorStateMessage({
    super.key,
    required this.message,
    this.icon,
    this.onRetryPressed,
    this.retryLabel,
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
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: AppDimensions.spacingM),
            ],
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetryPressed != null) ...[
              const SizedBox(height: AppDimensions.spacingM),
              TextButton.icon(
                onPressed: onRetryPressed,
                icon: const Icon(Icons.refresh),
                label: Text(retryLabel ?? 'Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
