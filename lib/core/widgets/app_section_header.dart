import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppSectionHeader extends StatelessWidget {
  final String text;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Color? shadowColor;
  final double? shadowOpacity;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Widget? trailing;

  const AppSectionHeader({
    Key? key,
    required this.text,
    this.textColor,
    this.fontWeight,
    this.shadowColor,
    this.shadowOpacity,
    this.padding,
    this.textStyle,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding ?? AppDimensions.sectionPadding,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: (shadowColor ?? AppColors.shadow).withOpacity(
              shadowOpacity ?? (isDark ? 0.15 : 0.03),
            ),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              text,
              style: textStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: textColor ?? AppColors.primary,
                    fontWeight: fontWeight ?? FontWeight.w500,
                  ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
