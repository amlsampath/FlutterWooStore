import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';
import '../theme/app_theme_extension.dart';
import 'app_elevated_button.dart';

class AppSummaryCard extends StatelessWidget {
  final String title;
  final String total;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final IconData? buttonIcon;
  final Color? buttonColor;
  final Color? totalColor;
  final TextStyle? titleStyle;
  final TextStyle? totalStyle;
  final EdgeInsetsGeometry? padding;
  final bool showShadow;
  final bool isDark;

  const AppSummaryCard({
    super.key,
    required this.title,
    required this.total,
    required this.buttonText,
    required this.onButtonPressed,
    this.buttonIcon,
    this.buttonColor,
    this.totalColor,
    this.titleStyle,
    this.totalStyle,
    this.padding,
    this.showShadow = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return Container(
      padding: padding ?? AppDimensions.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: AppColors.shadow.withOpacity(isDark ? 0.2 : 0.1),
                  blurRadius: AppDimensions.spacingM,
                  offset: const Offset(0, -2),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: titleStyle ?? theme.textTheme.titleLarge,
                ),
                Text(
                  total,
                  style: totalStyle ??
                      theme.textTheme.titleLarge?.copyWith(
                        color: totalColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacingM),
            AppElevatedButton(
              text: buttonText,
              onPressed: onButtonPressed,
              icon: buttonIcon,
              backgroundColor: buttonColor,
              minimumSize: const Size.fromHeight(AppDimensions.buttonHeightL),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
                vertical: AppDimensions.spacingM,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
