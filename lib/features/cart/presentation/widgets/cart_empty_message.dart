import 'package:flutter/material.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_elevated_button.dart';

class CartEmptyMessage extends StatelessWidget {
  final VoidCallback onStartShopping;

  const CartEmptyMessage({
    Key? key,
    required this.onStartShopping,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXL),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            Text(
              'Your cart is empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              "Looks like you haven't added any items to your cart yet.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingXL),
            SizedBox(
              width: double.infinity,
              child: AppElevatedButton(
                text: 'Start Shopping',
                onPressed: onStartShopping,
                icon: Icons.shopping_bag_outlined,
                minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
                backgroundColor: theme.colorScheme.onSurface,
                textColor: theme.scaffoldBackgroundColor,
                borderRadius: AppDimensions.borderRadiusM,
                elevation: 2,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
