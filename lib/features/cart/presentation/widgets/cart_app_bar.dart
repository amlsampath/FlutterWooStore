import 'package:flutter/material.dart';

import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/cart_icon_button.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final Color? titleColor;
  final TextStyle? titleStyle;
  final double? elevation;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onCartPressed;

  const CartAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.titleColor,
    this.titleStyle,
    this.elevation,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.bottom,
    this.onCartPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text(
        title,
        style: titleStyle ??
            theme.textTheme.titleLarge?.copyWith(
              color: titleColor ?? theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
      ),
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      elevation: elevation ?? 0,
      centerTitle: centerTitle,
      leading: leading,
      actions: [
        CartIconButton(
          onCartPressed: onCartPressed,
        ),
        if (actions != null) ...actions!,
        const SizedBox(width: AppDimensions.spacingS), // Add some padding at the end
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        bottom?.preferredSize.height ?? AppDimensions.appBarHeight,
      );
}
