import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isTotal = false,
    this.labelStyle,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultLabelStyle = theme.textTheme.bodyLarge?.copyWith(
      fontSize: isTotal ? 18 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: isTotal ? colorScheme.primary : theme.textTheme.bodyLarge?.color,
    );

    final defaultValueStyle = theme.textTheme.bodyLarge?.copyWith(
      fontSize: isTotal ? 18 : 16,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: isTotal ? colorScheme.primary : theme.textTheme.bodyLarge?.color,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: labelStyle ?? defaultLabelStyle,
          ),
          Text(
            value,
            style: valueStyle ?? defaultValueStyle,
          ),
        ],
      ),
    );
  }
}
