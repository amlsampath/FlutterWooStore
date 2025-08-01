import 'package:flutter/material.dart';
import '../theme/app_dimensions.dart';
import 'app_badge.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final int? badgeCount;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final double? badgeSize;
  final double? badgeFontSize;
  final bool showBadge;
  final bool isIconRequired;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.badgeCount,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeSize,
    this.badgeFontSize,
    this.showBadge = true,
    this.tooltip,
    this.isIconRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          isIconRequired
              ? IconButton(
                  icon: Icon(
                    icon,
                    color: iconColor ?? theme.colorScheme.onSurface,
                    size: iconSize ?? AppDimensions.iconSizeM,
                  ),
                  padding:
                      padding ?? const EdgeInsets.all(AppDimensions.spacingS),
                  onPressed: onPressed,
                  tooltip: tooltip,
                )
              : Container(),
          if (showBadge && badgeCount != null && badgeCount! > 0)
            Positioned(
              right: AppDimensions.spacingS,
              top: AppDimensions.spacingS,
              child: AppBadge(
                count: badgeCount!,
                backgroundColor: badgeColor,
                textColor: badgeTextColor,
                size: badgeSize,
                fontSize: badgeFontSize,
              ),
            ),
        ],
      ),
    );
  }
}
