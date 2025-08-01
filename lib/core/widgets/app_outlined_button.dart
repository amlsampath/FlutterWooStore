import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// A reusable outlined button widget with consistent styling
class AppOutlinedButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Called when the button is pressed
  final VoidCallback? onPressed;

  /// The text style for the button text
  final TextStyle? textStyle;

  /// Whether the button is enabled
  final bool enabled;

  /// The color of the button border and text
  final Color? foregroundColor;

  /// The color of the button when disabled
  final Color? disabledColor;

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

  /// The border radius of the button
  final double? borderRadius;

  /// The width of the button border
  final double? borderWidth;

  const AppOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textStyle,
    this.enabled = true,
    this.foregroundColor,
    this.disabledColor,
    this.padding,
    this.minimumSize,
    this.maximumSize,
    this.icon,
    this.trailingIcon,
    this.iconSize,
    this.iconSpacing,
    this.borderRadius,
    this.borderWidth,
  });

  /// Factory constructor for an outlined button with an icon
  factory AppOutlinedButton.icon({
    required IconData icon,
    required String text,
    VoidCallback? onPressed,
    Key? key,
  }) {
    return AppOutlinedButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor ?? theme.colorScheme.primary,
        disabledForegroundColor:
            disabledColor ?? theme.colorScheme.onSurface.withOpacity(0.38),
        padding: padding ?? AppDimensions.buttonPadding,
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        side: BorderSide(
          color: enabled
              ? (foregroundColor ?? theme.colorScheme.primary)
              : (disabledColor ??
                  theme.colorScheme.onSurface.withOpacity(0.38)),
          width: borderWidth ?? AppDimensions.borderWidthRegular,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppDimensions.borderRadiusS,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: iconSize ?? AppDimensions.iconSizeS,
              color: enabled
                  ? (foregroundColor ?? theme.colorScheme.primary)
                  : (disabledColor ??
                      theme.colorScheme.onSurface.withOpacity(0.38)),
            ),
            SizedBox(width: iconSpacing ?? AppDimensions.spacingS),
          ],
          Text(
            text,
            style: textStyle ??
                theme.textTheme.labelLarge?.copyWith(
                  color: enabled
                      ? (foregroundColor ?? theme.colorScheme.primary)
                      : (disabledColor ??
                          theme.colorScheme.onSurface.withOpacity(0.38)),
                ),
          ),
          if (trailingIcon != null) ...[
            SizedBox(width: iconSpacing ?? AppDimensions.spacingS),
            Icon(
              trailingIcon,
              size: iconSize ?? AppDimensions.iconSizeS,
              color: enabled
                  ? (foregroundColor ?? theme.colorScheme.primary)
                  : (disabledColor ??
                      theme.colorScheme.onSurface.withOpacity(0.38)),
            ),
          ],
        ],
      ),
    );
  }
}
