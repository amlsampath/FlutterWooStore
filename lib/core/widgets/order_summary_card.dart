import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import '../utils/currency_formatter.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double shippingCost;
  final double discount;
  final EdgeInsets? padding;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.shippingCost,
    required this.discount,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final total = subtotal + tax + shippingCost - discount;

    return Card(
      margin: padding ?? const EdgeInsets.all(AppDimensions.spacingM),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            _buildSummaryRow(context, 'Subtotal', subtotal),
            _buildSummaryRow(context, 'Tax', tax),
            _buildSummaryRow(context, 'Shipping', shippingCost),
            if (discount > 0) _buildSummaryRow(context, 'Discount', -discount),
            const Divider(),
            _buildSummaryRow(
              context,
              'Total',
              total,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    double amount, {
    bool isTotal = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textStyle = isTotal
        ? theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          )
        : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textStyle,
          ),
          CurrencyFormatter.formatPriceText(
            amount.toString(),
            context: context,
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ],
      ),
    );
  }
}
