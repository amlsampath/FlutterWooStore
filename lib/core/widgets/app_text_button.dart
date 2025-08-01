import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// A reusable text button widget with consistent styling
class AppTextButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Called when the button is pressed
  final VoidCallback? onPressed;

  /// The text style for the button text
  final TextStyle? textStyle;

  /// Whether the button is enabled
  final bool enabled;

  /// The color of the button text
  final Color? textColor;

  /// The color of the button text when disabled
  final Color? disabledTextColor;

  /// The padding around the button content
  final EdgeInsetsGeometry? padding;

  /// The minimum size of the button
  final Size? minimumSize;

  /// The maximum size of the button
  final Size? maximumSize;

  /// The icon to display before the text
  final IconData? icon;

  /// The icon to display after the text
  final IconData? trailingIcon;

  /// The size of the icons
  final double? iconSize;

  /// The spacing between the icon and text
  final double? iconSpacing;

  const AppTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textStyle,
    this.enabled = true,
    this.textColor,
    this.disabledTextColor,
    this.padding,
    this.minimumSize,
    this.maximumSize,
    this.icon,
    this.trailingIcon,
    this.iconSize,
    this.iconSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextButton(
      onPressed: enabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? theme.colorScheme.primary,
        disabledForegroundColor:
            disabledTextColor ?? theme.colorScheme.onSurface.withOpacity(0.38),
        padding: padding ?? AppDimensions.buttonPadding,
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        textStyle: textStyle ??
            theme.textTheme.labelLarge?.copyWith(
              color: textColor ?? theme.colorScheme.primary,
            ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? AppDimensions.iconSizeS,
              color: enabled
                  ? (textColor ?? theme.colorScheme.primary)
                  : (disabledTextColor ??
                      theme.colorScheme.onSurface.withOpacity(0.38)),
            ),
            SizedBox(width: iconSpacing ?? AppDimensions.spacingS),
          ],
          Text(text),
          if (trailingIcon != null) ...[
            SizedBox(width: iconSpacing ?? AppDimensions.spacingS),
            Icon(
              trailingIcon,
              size: iconSize ?? AppDimensions.iconSizeS,
              color: enabled
                  ? (textColor ?? theme.colorScheme.primary)
                  : (disabledTextColor ??
                      theme.colorScheme.onSurface.withOpacity(0.38)),
            ),
          ],
        ],
      ),
    );
  }
}
