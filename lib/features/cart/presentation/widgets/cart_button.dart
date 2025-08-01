import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_icon_button.dart';
import '../bloc/cart_bloc.dart';

class CartButton extends StatelessWidget {
  final Color? iconColor;
  final VoidCallback? onPressed;
  final double? iconSize;
  final double? badgeSize;
  final EdgeInsetsGeometry? padding;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final double? badgeFontSize;
  final bool showBadge;
  final bool isIconRequired;

  const CartButton({
    super.key,
    this.iconColor,
    this.onPressed,
    this.iconSize,
    this.badgeSize,
    this.padding,
    this.badgeColor,
    this.badgeTextColor,
    this.badgeFontSize,
    this.showBadge = true,
    this.isIconRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        int itemCount = 0;
        if (state is CartLoaded) {
          itemCount = state.items.fold(0, (sum, item) => sum + item.quantity);
        }

        return AppIconButton(
          icon: Icons.shopping_cart_outlined,
          iconColor: iconColor,
          iconSize: iconSize,
          padding: padding,
          onPressed: onPressed ?? () => context.push('/cart'),
          badgeCount: itemCount,
          badgeColor: badgeColor,
          badgeTextColor: badgeTextColor,
          badgeSize: badgeSize,
          badgeFontSize: badgeFontSize,
          showBadge: showBadge,
          tooltip: 'Cart',
          isIconRequired: isIconRequired,
        );
      },
    );
  }
}
