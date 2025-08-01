import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class AppErrorView extends StatelessWidget {
  final String message;
  final String? retryLabel;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Color? iconColor;
  final Color? textColor;

  const AppErrorView({
    super.key,
    required this.message,
    this.retryLabel,
    this.onRetry,
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
              color: iconColor ?? theme.colorScheme.error,
              size: 48,
            ),
            const SizedBox(height: AppDimensions.spacingM),
          ],
          Text(
            message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: textColor ?? theme.colorScheme.error,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppDimensions.spacingS),
            TextButton.icon(
              onPressed: onRetry,
              icon: Icon(
                Icons.refresh,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                retryLabel ?? 'Retry',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
