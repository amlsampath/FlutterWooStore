import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ErrorText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ErrorText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      style: (style ?? theme.textTheme.bodyLarge)?.copyWith(
        color: AppColors.error,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
