import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class ErrorList extends StatelessWidget {
  final List<String> items;
  final EdgeInsets? padding;

  const ErrorList({
    super.key,
    required this.items,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDimensions.spacingS),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.spacingS,
                bottom: AppDimensions.spacingXS,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: AppDimensions.iconSizeS,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: AppDimensions.spacingXS),
                  Expanded(
                    child: Text(
                      item,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
