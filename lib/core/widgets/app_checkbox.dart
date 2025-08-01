import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// A reusable checkbox widget with consistent styling
class AppCheckbox extends StatelessWidget {
  /// The current value of the checkbox
  final bool value;

  /// Called when the value of the checkbox should change
  final ValueChanged<bool?>? onChanged;

  /// The label text to display next to the checkbox
  final String? label;

  /// The text style for the label
  final TextStyle? labelStyle;

  /// Whether the checkbox is enabled
  final bool enabled;

  /// The color of the checkbox when it's checked
  final Color? activeColor;

  /// The color of the checkbox when it's unchecked
  final Color? inactiveColor;

  /// The color of the checkbox's border
  final Color? borderColor;

  /// The size of the checkbox
  final double? size;

  /// The spacing between the checkbox and the label
  final double? spacing;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelStyle,
    this.enabled = true,
    this.activeColor,
    this.inactiveColor,
    this.borderColor,
    this.size,
    this.spacing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size ?? AppDimensions.iconSizeM,
          height: size ?? AppDimensions.iconSizeM,
          child: Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
            activeColor: activeColor ?? theme.colorScheme.primary,
            checkColor: theme.colorScheme.onPrimary,
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return theme.colorScheme.onSurface.withOpacity(0.38);
              }
              if (states.contains(WidgetState.selected)) {
                return activeColor ?? theme.colorScheme.primary;
              }
              return inactiveColor ?? theme.colorScheme.surface;
            }),
            side: BorderSide(
              color: borderColor ?? theme.colorScheme.outline,
              width: AppDimensions.borderWidthThin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusXS),
            ),
          ),
        ),
        if (label != null) ...[
          SizedBox(width: spacing ?? AppDimensions.spacingS),
          Text(
            label!,
            style: labelStyle ?? theme.textTheme.bodyMedium,
          ),
        ],
      ],
    );
  }
}
