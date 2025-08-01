import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// A reusable elevated button widget with consistent styling
class AppElevatedButton extends StatelessWidget {
  /// The text to display on the button
  final String text;

  /// Called when the button is pressed
  final VoidCallback? onPressed;

  /// The text style for the button text
  final TextStyle? textStyle;

  /// Whether the button is enabled
  final bool enabled;

  /// The color of the button background
  final Color? backgroundColor;

  /// The color of the button text
  final Color? textColor;

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

  /// The elevation of the button
  final double? elevation;

  /// The border radius of the button
  final double? borderRadius;

  /// Whether to show a loading indicator
  final bool isLoading;

  /// The size of the loading indicator
  final double? loadingIndicatorSize;

  /// The color of the loading indicator
  final Color? loadingIndicatorColor;

  const AppElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
    this.textStyle,
    this.enabled = true,
    this.backgroundColor,
    this.textColor,
    this.disabledColor,
    this.padding,
    this.minimumSize,
    this.maximumSize,
    this.icon,
    this.trailingIcon,
    this.iconSize,
    this.iconSpacing,
    this.elevation,
    this.borderRadius,
    this.isLoading = false,
    this.loadingIndicatorSize,
    this.loadingIndicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: enabled && !isLoading ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: textColor ?? theme.colorScheme.onPrimary,
        disabledBackgroundColor:
            disabledColor ?? theme.colorScheme.onSurface.withOpacity(0.12),
        disabledForegroundColor: theme.colorScheme.onSurface.withOpacity(0.38),
        padding: padding ?? AppDimensions.buttonPadding,
        minimumSize: minimumSize,
        maximumSize: maximumSize,
        elevation: elevation ?? 2,
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
          if (isLoading)
            SizedBox(
              width: loadingIndicatorSize ?? AppDimensions.iconSizeS,
              height: loadingIndicatorSize ?? AppDimensions.iconSizeS,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: loadingIndicatorColor ?? theme.colorScheme.onPrimary,
              ),
            )
          else ...[
            if (icon != null) ...[
              Icon(
                icon,
                size: iconSize ?? AppDimensions.iconSizeS,
                color: textColor ?? theme.colorScheme.onPrimary,
              ),
              SizedBox(width: iconSpacing ?? AppDimensions.spacingS),
            ],
            Text(
              text,
              style: textStyle ??
                  theme.textTheme.labelLarge?.copyWith(
                    color: textColor ?? theme.colorScheme.onPrimary,
                  ),
            ),
            if (trailingIcon != null) ...[
              SizedBox(width: iconSpacing ?? AppDimensions.spacingS),
              Icon(
                trailingIcon,
                size: iconSize ?? AppDimensions.iconSizeS,
                color: textColor ?? theme.colorScheme.onPrimary,
              ),
            ],
          ],
        ],
      ),
    );
  }
}
