import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final TextStyle? messageStyle;
  final TextStyle? buttonStyle;
  final Color? buttonColor;

  const AppErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.icon,
    this.iconSize,
    this.iconColor,
    this.messageStyle,
    this.buttonStyle,
    this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultIconColor = iconColor ?? theme.colorScheme.error;
    final defaultIconSize = iconSize ?? 64.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: defaultIconSize,
            color: defaultIconColor,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            message,
            style: (messageStyle ?? theme.textTheme.bodyLarge)?.copyWith(
              color: defaultIconColor,
            ),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppDimensions.spacingM),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor ?? theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                textStyle: buttonStyle,
              ),
              child: Text(retryLabel!),
            ),
          ],
        ],
      ),
    );
  }
}
