import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../domain/entities/cart_item.dart';
import '../bloc/cart_bloc.dart';

class AddToCartButton extends StatefulWidget {
  final int productId;
  final String name;
  final String imageUrl;
  final String price;
  final bool isExpanded;
  final Color? buttonColor;
  final double? borderRadius;
  final String? selectedColor;
  final String? selectedSize;
  final Map<String, String>? additionalAttributes;
  final bool Function()? onPressed;
  final VoidCallback? onAddedToCart;
  final String? buttonLabel;
  final IconData? icon;
  final double? iconSize;
  final EdgeInsetsGeometry? padding;
  final bool isLoading;
  final bool showSnackbar;

  const AddToCartButton({
    super.key,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.isExpanded = true,
    this.buttonColor,
    this.borderRadius,
    this.selectedColor,
    this.selectedSize,
    this.additionalAttributes,
    this.onPressed,
    this.onAddedToCart,
    this.buttonLabel,
    this.icon,
    this.iconSize,
    this.padding,
    this.isLoading = false,
    this.showSnackbar = true,
  });

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _runAnimationAndAddToCart(BuildContext context) async {
    setState(() => _isAnimating = true);
    await _controller.forward();
    await _controller.reverse();
    setState(() => _isAnimating = false);

    // Run validation if provided
    if (widget.onPressed != null) {
      final isValid = widget.onPressed!();
      if (!isValid) {
        return; // Stop if validation failed
      }
    }

    // Trigger the animation before adding to cart
    if (widget.onAddedToCart != null) {
      widget.onAddedToCart!();
    }

    final cartItem = CartItem(
      productId: widget.productId,
      name: widget.name,
      imageUrl: widget.imageUrl,
      price: widget.price,
      quantity: 1,
      selectedColor: widget.selectedColor,
      selectedSize: widget.selectedSize,
      additionalAttributes: widget.additionalAttributes,
    );
    context.read<CartBloc>().add(AddCartItem(cartItem));

    if (widget.showSnackbar) {
      // Display message including selections
      String message = 'Added to cart';
      if (widget.selectedSize != null || widget.selectedColor != null) {
        message += ' (';
        if (widget.selectedSize != null) {
          message += 'Size: ${widget.selectedSize}';
          if (widget.selectedColor != null) message += ', ';
        }
        if (widget.selectedColor != null) {
          message += 'Color: ${widget.selectedColor}';
        }
        message += ')';
      }
      SnackbarUtils.showSuccess(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.buttonColor ?? AppColors.primary;

    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return SizedBox(
          width: widget.isExpanded ? double.infinity : null,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: FilledButton.icon(
              onPressed: widget.isLoading || _isAnimating
                  ? null
                  : () => _runAnimationAndAddToCart(context),
              icon: widget.isLoading
                  ? SizedBox(
                      width: widget.iconSize ?? AppDimensions.iconSizeM,
                      height: widget.iconSize ?? AppDimensions.iconSizeM,
                      child: AppLoadingIndicator(
                        color: theme.colorScheme.onPrimary,
                        strokeWidth: AppDimensions.borderWidthRegular,
                      ),
                    )
                  : Icon(
                      widget.icon ?? Icons.shopping_cart,
                      color: theme.colorScheme.onPrimary,
                      size: widget.iconSize ?? AppDimensions.iconSizeM,
                    ),
              label: Text(
                widget.buttonLabel ?? 'Add to Cart',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? AppDimensions.borderRadiusL,
                  ),
                ),
                padding: widget.padding ??
                    const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingL,
                      vertical: AppDimensions.spacingM,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
