import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_elevated_button.dart';

class CartErrorMessage extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const CartErrorMessage({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: AppDimensions.iconSizeXL,
            color: theme.colorScheme.error,
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'Error loading cart',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            child: Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingL),
          AppElevatedButton(
            text: 'Retry',
            onPressed: onRetry,
            icon: Icons.refresh,
            minimumSize: const Size.fromHeight(AppDimensions.buttonHeightM),
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingL,
              vertical: AppDimensions.spacingM,
            ),
          ),
        ],
      ),
    );
  }
}
