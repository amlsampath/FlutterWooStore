import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_colors.dart';
import 'app_text_button.dart';

class ShippingMethodCard extends StatelessWidget {
  final String methodTitle;
  final String methodDescription;
  final VoidCallback onChange;
  final bool isSelected;

  const ShippingMethodCard({
    super.key,
    required this.methodTitle,
    required this.methodDescription,
    required this.onChange,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
      ),
      elevation: isSelected ? 4 : 1,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppDimensions.spacingS),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_shipping_outlined,
            size: AppDimensions.iconSizeM,
          ),
        ),
        title: Text(
          methodTitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(methodDescription),
        trailing: AppTextButton(
          text: 'CHANGE',
          onPressed: onChange,
        ),
      ),
    );
  }
}
