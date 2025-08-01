import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';

class OrderSubmissionShimmer extends StatelessWidget {
  const OrderSubmissionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: appTheme.borderRadiusM,
        side: BorderSide(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Padding(
        padding: appTheme.paddingM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimensions.spacingM),
            Icon(
              Icons.shopping_cart_checkout_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Submitting your order',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Please wait while we process your order and payment.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            // Progress indicator
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            // Processing steps
            ...List.generate(
              3,
              (index) => _buildProcessingStep(theme, index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingStep(ThemeData theme, int index) {
    final steps = [
      'Validating order details',
      'Processing payment',
      'Creating your order',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingS,
        horizontal: AppDimensions.spacingM,
      ),
      child: Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        highlightColor:
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: theme.cardColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Text(
                steps[index],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.cardColor,
                ),
              ),
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius:
                    BorderRadius.circular(AppDimensions.borderRadiusS),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
