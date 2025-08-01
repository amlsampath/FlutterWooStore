import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// A reusable card widget for displaying address information
class AddressCard extends StatelessWidget {
  /// The address information to display
  final String address;

  /// The city
  final String city;

  /// The state/province
  final String state;

  /// The postal/zip code
  final String zip;

  /// The first name
  final String firstName;

  /// The last name
  final String lastName;

  /// The icon to display in the leading position
  final IconData? leadingIcon;

  /// The text to display on the trailing button
  final String? trailingButtonText;

  /// Called when the trailing button is pressed
  final VoidCallback? onTrailingButtonPressed;

  /// The color of the leading icon
  final Color? iconColor;

  /// The color of the trailing button
  final Color? trailingButtonColor;

  /// The style of the trailing button text
  final TextStyle? trailingButtonStyle;

  /// The shape of the card
  final ShapeBorder? shape;

  /// The elevation of the card
  final double? elevation;

  /// The margin of the card
  final EdgeInsetsGeometry? margin;

  /// The padding of the card
  final EdgeInsetsGeometry? padding;

  const AddressCard({
    super.key,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
    required this.firstName,
    required this.lastName,
    this.leadingIcon,
    this.trailingButtonText,
    this.onTrailingButtonPressed,
    this.iconColor,
    this.trailingButtonColor,
    this.trailingButtonStyle,
    this.shape,
    this.elevation,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      shape: shape ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadiusM),
          ),
      elevation: elevation,
      margin: margin,
      child: ListTile(
        leading: Icon(
          leadingIcon ?? Icons.location_on_outlined,
          color: iconColor ?? colorScheme.primary,
          size: AppDimensions.iconSizeM,
        ),
        title: Text(
          '$address, $city, $state $zip',
          style: theme.textTheme.bodyLarge,
        ),
        subtitle: Text(
          '$firstName $lastName',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: trailingButtonText != null
            ? TextButton(
                onPressed: onTrailingButtonPressed,
                style: TextButton.styleFrom(
                  foregroundColor: trailingButtonColor ?? colorScheme.primary,
                  textStyle: trailingButtonStyle ??
                      theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                child: Text(trailingButtonText!),
              )
            : null,
        contentPadding: padding ?? const EdgeInsets.all(AppDimensions.spacingM),
      ),
    );
  }
}
