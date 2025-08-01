import 'package:flutter/material.dart';
import 'package:ecommerce_app/features/products/domain/entities/product.dart';

class FlyToCartAnimation {
  static void animate({
    required BuildContext context,
    required GlobalKey imageKey,
    required GlobalKey cartIconKey,
    required Product product,
    required VoidCallback onComplete,
  }) {
    final sourceBox = imageKey.currentContext?.findRenderObject() as RenderBox?;
    final cartBox =
        cartIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (sourceBox == null || cartBox == null) {
      onComplete();
      return;
    }

    final sourcePosition = sourceBox.localToGlobal(Offset.zero);
    final cartPosition = cartBox.localToGlobal(Offset.zero);

    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedProductImage(
        sourcePosition: sourcePosition,
        cartPosition: cartPosition,
        imageUrl: product.imageUrls.first,
        onComplete: () {
          overlayEntry.remove();
          onComplete();
        },
      ),
    );

    Overlay.of(context).insert(overlayEntry);
  }
}

class _AnimatedProductImage extends StatefulWidget {
  final Offset sourcePosition;
  final Offset cartPosition;
  final String imageUrl;
  final VoidCallback onComplete;

  const _AnimatedProductImage({
    required this.sourcePosition,
    required this.cartPosition,
    required this.imageUrl,
    required this.onComplete,
  });

  @override
  State<_AnimatedProductImage> createState() => _AnimatedProductImageState();
}

class _AnimatedProductImageState extends State<_AnimatedProductImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _positionAnimation = Tween<Offset>(
      begin: widget.sourcePosition,
      end: widget.cartPosition,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _positionAnimation.value.dx,
          top: _positionAnimation.value.dy,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Image.network(
                widget.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
