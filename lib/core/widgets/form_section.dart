import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

class FormSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsets? padding;
  final TextStyle? titleStyle;

  const FormSection({
    super.key,
    required this.title,
    required this.children,
    this.padding,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppDimensions.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: titleStyle ??
                theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          ...children,
        ],
      ),
    );
  }
}
