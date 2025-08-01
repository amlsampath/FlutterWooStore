import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import 'app_elevated_button.dart';

class SummaryItem {
  final String label;
  final String value;
  final Color? valueColor;

  const SummaryItem({
    required this.label,
    required this.value,
    this.valueColor,
  });
}

class AppBottomSummary extends StatelessWidget {
  final List<SummaryItem> items;
  final String totalLabel;
  final String totalValue;
  final String buttonLabel;
  final IconData? buttonIcon;
  final VoidCallback onButtonPressed;
  final Color? totalValueColor;
  final EdgeInsetsGeometry? padding;

  const AppBottomSummary({
    super.key,
    required this.items,
    required this.totalLabel,
    required this.totalValue,
    required this.buttonLabel,
    required this.onButtonPressed,
    this.buttonIcon,
    this.totalValueColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: padding ?? AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: AppDimensions.spacingM,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...items.map((item) => _buildSummaryRow(
                  context,
                  label: item.label,
                  value: item.value,
                  valueColor: item.valueColor,
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
              child: Divider(color: theme.dividerTheme.color),
            ),
            _buildSummaryRow(
              context,
              label: totalLabel,
              value: totalValue,
              valueColor: totalValueColor ?? AppColors.primary,
              isTotal: true,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppElevatedButton(
              text: buttonLabel,
              onPressed: onButtonPressed,
              icon: buttonIcon,
              minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    Color? valueColor,
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: (isTotal
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.bodyMedium)
                ?.copyWith(
              color: isTotal
                  ? theme.textTheme.titleMedium?.color
                  : theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: (isTotal
                    ? theme.textTheme.titleLarge
                    : theme.textTheme.bodyMedium)
                ?.copyWith(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
