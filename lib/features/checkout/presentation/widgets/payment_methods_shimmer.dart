import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';

class PaymentMethodsShimmer extends StatelessWidget {
  const PaymentMethodsShimmer({super.key});

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
              Icons.payments_rounded,
              color: Theme.of(context).colorScheme.primary,
              size: 40,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Loading payment methods',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Please wait while we fetch secure payment options for you.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            ...List.generate(
              4,
              (index) => _buildShimmerField(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerField(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacingS,
        horizontal: AppDimensions.spacingM,
      ),
      child: Shimmer.fromColors(
        baseColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
        highlightColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.6),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: theme.cardColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadiusS),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Container(
                    height: 12,
                    width: 200,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadiusS),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            Container(
              width: 24,
              height: 24,
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
