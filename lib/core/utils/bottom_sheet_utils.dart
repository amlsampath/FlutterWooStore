import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';

/// A utility class for showing consistent bottom sheets throughout the app
class BottomSheetUtils {
  /// Shows a bottom sheet with consistent styling
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsets? padding,
    bool showDragHandle = true,
  }) {
    final theme = Theme.of(context);

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppDimensions.borderRadiusL),
            ),
          ),
      builder: (context) => Padding(
        padding: padding ??
            EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDragHandle) ...[
              const SizedBox(height: AppDimensions.spacingS),
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
            ],
            Flexible(child: child),
          ],
        ),
      ),
    );
  }

  /// Shows a bottom sheet with a form
  static Future<T?> showForm<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsets? padding,
    bool showDragHandle = true,
  }) {
    return show<T>(
      context: context,
      child: child,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      padding: padding,
      showDragHandle: showDragHandle,
    );
  }

  /// Shows a bottom sheet with a list
  static Future<T?> showList<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsets? padding,
    bool showDragHandle = true,
  }) {
    return show<T>(
      context: context,
      child: child,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      padding: padding,
      showDragHandle: showDragHandle,
    );
  }
}
