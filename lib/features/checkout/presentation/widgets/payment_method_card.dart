import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';

class PaymentMethodCard extends StatelessWidget {
  final List<Map<String, dynamic>> paymentMethods;
  final String? selectedMethodId;
  final ValueChanged<String?> onMethodSelected;

  const PaymentMethodCard({
    super.key,
    required this.paymentMethods,
    required this.selectedMethodId,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return Column(
      children: [
        for (int i = 0; i < paymentMethods.length; i++) ...[
          Card(
            elevation: 0,
            margin: EdgeInsets.only(
              bottom:
                  i == paymentMethods.length - 1 ? 0 : AppDimensions.spacingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: appTheme.borderRadiusM,
              side: BorderSide(
                color: theme.colorScheme.outline.withOpacity(0.08),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.spacingM,
                horizontal: AppDimensions.spacingM,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Radio<String>(
                    value: paymentMethods[i]['id'] as String,
                    groupValue: selectedMethodId,
                    onChanged: (paymentMethods[i]['enabled'] as bool? ?? false)
                        ? (value) => onMethodSelected(value)
                        : null,
                    activeColor: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paymentMethods[i]['title'] as String,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: AppDimensions.spacingXS),
                        Text(
                          paymentMethods[i]['description'] as String? ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  IconData _getPaymentMethodIcon(String methodId) {
    switch (methodId) {
      case 'bacs':
        return Icons.account_balance;
      case 'cod':
        return Icons.money;
      case 'payhere':
      case 'payhere_payment':
        return Icons.credit_card;
      default:
        return Icons.payment;
    }
  }
}
