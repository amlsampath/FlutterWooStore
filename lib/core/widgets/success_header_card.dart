import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class SuccessHeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Color? iconColor;

  const SuccessHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: theme.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          children: [
            Icon(
              icon ?? Icons.check_circle,
              color: iconColor ?? colorScheme.primary,
              size: AppDimensions.iconSizeXL,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              subtitle,
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
