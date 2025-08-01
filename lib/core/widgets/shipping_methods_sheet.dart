import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class ShippingMethodsSheet extends StatelessWidget {
  final List<Map<String, dynamic>> methods;
  final String? selectedMethodId;
  final void Function(String) onMethodSelected;

  const ShippingMethodsSheet({
    super.key,
    required this.methods,
    required this.selectedMethodId,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Choose Shipping Method',
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          ...methods.map((method) {
            final methodId = method['id'].toString();
            final isSelected = methodId == selectedMethodId;
            final title = method['title'] ?? 'Shipping Method';
            final description = method['method_id'] == 'free_shipping'
                ? 'Free - Delivered within 3-5 business days'
                : 'Standard shipping rates apply';

            return Container(
              margin: const EdgeInsets.only(bottom: AppDimensions.spacingS),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.surfaceContainerHighest.withOpacity(0.7)
                    : theme.cardColor,
                borderRadius:
                    BorderRadius.circular(AppDimensions.borderRadiusM),
                border: isSelected
                    ? Border.all(color: colorScheme.primary, width: 2)
                    : null,
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingS),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary.withOpacity(0.15)
                        : colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_shipping_outlined,
                    size: AppDimensions.iconSizeM,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                title: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
                subtitle: Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                trailing: isSelected
                    ? Icon(Icons.check_circle, color: colorScheme.primary)
                    : null,
                onTap: () => onMethodSelected(methodId),
                selected: isSelected,
                selectedTileColor: colorScheme.primary.withOpacity(0.08),
              ),
            );
          }).toList(),
          const SizedBox(height: AppDimensions.spacingM),
        ],
      ),
    );
  }
}
