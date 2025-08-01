import 'dart:math' as math;
import 'dart:math' show Random;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../features/cart/presentation/widgets/add_to_cart_button.dart';
import '../../../../features/cart/presentation/widgets/cart_button.dart';
import '../../../../features/favorites/presentation/widgets/favorite_button.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_details_shimmer.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/app_size_selector.dart';
import '../../../../core/widgets/app_color_selector.dart';
import '../../../../core/widgets/app_product_attributes.dart';
import '../../../../core/widgets/app_app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../browsing_history/domain/entities/browsing_history_item.dart';
import '../../../browsing_history/presentation/cubit/browsing_history_cubit.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  int _currentImageIndex = 0;
  bool _isLoading = true;
  bool _imagesPreloaded = false;
  String? _selectedSize;
  String? _selectedColor;

  // Animation related properties
  final GlobalKey _cartIconKey = GlobalKey();
  final GlobalKey _productImageKey = GlobalKey();
  AnimationController? _animationController;
  Animation<double>? _animation;
  Animation<double>? _scaleAnimation;
  Animation<double>? _bounceAnimation;
  OverlayEntry? _overlayEntry;
  OverlayEntry? _particleOverlayEntry;

  // Parse attributes from product data
  List<String> _extractSizes() {
    for (final attribute in widget.product.attributes) {
      if (attribute.toLowerCase().contains('size')) {
        final parts = attribute.split(':');
        if (parts.length > 1) {
          return parts[1].split(',').map((e) => e.trim()).toList();
        }
      }
    }
    return [];
  }

  Map<String, String> _extractColors() {
    final colorMap = <String, String>{};
    for (final attribute in widget.product.attributes) {
      if (attribute.toLowerCase().contains('color')) {
        final parts = attribute.split(':');
        if (parts.length > 1) {
          final colorValues = parts[1].split(',');
          for (final colorValue in colorValues) {
            final colorParts = colorValue.trim().split('#');
            if (colorParts.length > 1) {
              colorMap[colorParts[0].trim()] = '#${colorParts[1].trim()}';
            } else {
              colorMap[colorValue.trim()] = '';
            }
          }
        }
      }
    }
    return colorMap;
  }

  @override
  void initState() {
    super.initState();

    // Set initial selected size if available
    final sizes = _extractSizes();
    if (sizes.isNotEmpty) {
      _selectedSize = sizes.first;
    }

    // Set initial selected color if available
    final colors = _extractColors();
    if (colors.isNotEmpty) {
      _selectedColor = colors.keys.first;
    }

    // Initialize animation controller with a slightly longer duration
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Main animation for position
    _animation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOutCubic,
    );

    // Scale animation with custom curve
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.4)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 80,
      ),
    ]).animate(_animationController!);

    // Bounce animation when reaching the cart
    _bounceAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.0)
            .chain(CurveTween(curve: Curves.linear)),
        weight: 75, // Start bouncing at 75% of animation
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 10,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.3, end: 0.95)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.05)
            .chain(CurveTween(curve: Curves.easeOutQuad)),
        weight: 5,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInQuad)),
        weight: 5,
      ),
    ]).animate(_animationController!);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Trigger haptic feedback when animation ends
        HapticFeedback.mediumImpact();
        _showCartParticles();

        // Delay to show particles before removing animation
        Future.delayed(const Duration(milliseconds: 500), () {
          _removeCartAnimation();
        });
      }
    });

    // Save to browsing history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cubit = context.read<BrowsingHistoryCubit>();
      final p = widget.product;
      cubit.addProductToHistory(
        BrowsingHistoryItem(
          id: p.id,
          name: p.name,
          slug: p.slug,
          permalink: p.permalink,
          description: p.description,
          shortDescription: p.shortDescription,
          price: p.price,
          regularPrice: p.regularPrice,
          salePrice: p.salePrice,
          imageUrls: p.imageUrls,
          categories: p.categories,
          attributes: p.attributes,
          stockStatus: p.stockStatus,
          priceHtml: p.priceHtml,
          viewedAt: DateTime.now(),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPreloaded) {
      _preloadImages();
      _imagesPreloaded = true;
    }
  }

  Future<void> _preloadImages() async {
    for (final url in widget.product.imageUrls) {
      await precacheImage(NetworkImage(url), context);
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _removeCartAnimation();
    _removeParticleAnimation();
    super.dispose();
  }

  // Cart animation methods
  void _runCartAnimation() {
    if (_animationController == null) return;

    // Play a tap sound and light haptic feedback
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.lightImpact();

    // Get the positions for start and end of the animation
    final RenderBox? productBox =
        _productImageKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? cartBox =
        _cartIconKey.currentContext?.findRenderObject() as RenderBox?;

    if (productBox == null || cartBox == null) return;

    final Offset productPosition = productBox.localToGlobal(Offset.zero);
    final Offset cartPosition = cartBox.localToGlobal(Offset.zero);

    // Create overlay entry for the animation
    _overlayEntry = OverlayEntry(
      builder: (context) => AnimatedBuilder(
        animation: _animationController!,
        builder: (context, child) {
          // Calculate the current position of the animated product using cubic bezier
          // Add a slight arc to make movement more natural
          final progress = _animation!.value;

          // Add a curve to the path by using quadratic bezier
          final double controlPointX = productPosition.dx - 40;
          final double controlPointY = productPosition.dy > cartPosition.dy
              ? productPosition.dy - 100 // If cart is above product
              : productPosition.dy + 100; // If cart is below product

          final double x = _lerpWithBezier(
            productPosition.dx + (productBox.size.width / 2),
            cartPosition.dx + (cartBox.size.width / 2),
            controlPointX,
            progress,
          );

          final double y = _lerpWithBezier(
            productPosition.dy + (productBox.size.height / 2),
            cartPosition.dy + (cartBox.size.height / 2),
            controlPointY,
            progress,
          );

          // Scale based on animation with bounce effect at the end
          double scale = _scaleAnimation!.value;

          // Apply bounce effect near the end of animation
          if (progress > 0.75) {
            scale *= _bounceAnimation!.value;
          }

          // Add rotation as item flies
          final rotation = math.sin(progress * math.pi * 2) * 0.2;

          // Add shadow that grows as item moves
          final shadowOpacity = math.min(0.4, progress * 0.5);
          final shadowBlur = 20.0 * progress;

          return Positioned(
            left: x - 40 * scale,
            top: y - 40 * scale,
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(shadowOpacity),
                        blurRadius: shadowBlur,
                        spreadRadius: shadowBlur * 0.3,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: widget.product.imageUrls.isNotEmpty
                        ? Image.network(
                            widget.product.imageUrls[_currentImageIndex],
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );

    // Add overlay to the screen
    Overlay.of(context).insert(_overlayEntry!);

    // Start the animation
    _animationController!.forward(from: 0.0);
  }

  // Bezier curve interpolation for smoother motion
  double _lerpWithBezier(
      double start, double end, double controlPoint, double t) {
    final t1 = 1.0 - t;
    return t1 * t1 * start + 2 * t1 * t * controlPoint + t * t * end;
  }

  // Show particle effects when item reaches cart
  void _showCartParticles() {
    // Get cart position
    final RenderBox? cartBox =
        _cartIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (cartBox == null) return;

    final Offset cartPosition = cartBox.localToGlobal(Offset.zero);
    final double centerX = cartPosition.dx + (cartBox.size.width / 2);
    final double centerY = cartPosition.dy + (cartBox.size.height / 2);

    _particleOverlayEntry = OverlayEntry(
      builder: (context) => CartParticleEffect(
        centerX: centerX,
        centerY: centerY,
        color: Theme.of(context).primaryColor,
        onComplete: _removeParticleAnimation,
      ),
    );

    Overlay.of(context).insert(_particleOverlayEntry!);
  }

  void _removeCartAnimation() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _removeParticleAnimation() {
    _particleOverlayEntry?.remove();
    _particleOverlayEntry = null;
  }

  String _getCategoryName() {
    if (widget.product.categories.isNotEmpty) {
      return widget.product.categories.first;
    }
    return '';
  }

  // Extract average rating from product data if available
  String _getAverageRating() {
    // In a real app, this would extract the rating from product metadata
    // For now, we'll return an empty string as ratings aren't in the model
    return '';
  }

  // Collect additional attributes not related to size or color
  Map<String, String>? _getAdditionalAttributes() {
    final additionalAttributes = <String, String>{};

    // Extract brand if available
    for (final attribute in widget.product.attributes) {
      if (attribute.toLowerCase().contains('brand:')) {
        final parts = attribute.split(':');
        if (parts.length > 1) {
          additionalAttributes['brand'] = parts[1].trim();
        }
      }

      // Extract thickness if available
      else if (attribute.toLowerCase().contains('thickness:')) {
        final parts = attribute.split(':');
        if (parts.length > 1) {
          additionalAttributes['thickness'] = parts[1].trim();
        }
      }

      // Extract diameter if available
      else if (attribute.toLowerCase().contains('diameter:')) {
        final parts = attribute.split(':');
        if (parts.length > 1) {
          additionalAttributes['diameter'] = parts[1].trim();
        }
      }

      // Extract other attributes that aren't already handled
      else if (!attribute.toLowerCase().contains('size:') &&
          !attribute.toLowerCase().contains('color:')) {
        final parts = attribute.split(':');
        if (parts.length > 1) {
          // Use the attribute name as the key
          final key = parts[0].trim().toLowerCase();
          additionalAttributes[key] = parts[1].trim();
        }
      }
    }

    return additionalAttributes.isNotEmpty ? additionalAttributes : null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? AppColors.background : AppColors.surface;
    final cardColor = isDarkMode ? AppColors.surface : AppColors.surface;
    const textColor = AppColors.textPrimary;
    const subTextColor = AppColors.textSecondary;
    const primaryColor = AppColors.primary;

    // Dynamic data
    final sizes = _extractSizes();
    final colors = _extractColors();
    final rating = _getAverageRating();

    return Scaffold(
      appBar: AppAppBar(
        title: '',
        actions: [
          CartButton(
            key: _cartIconKey,
            // iconColor: textColor,
          ),
          FavoriteButton(
            productId: widget.product.id,
            name: widget.product.name,
            imageUrl: widget.product.imageUrls.isNotEmpty
                ? widget.product.imageUrls.first
                : '',
            price: widget.product.price,
            iconColor: textColor,
          ),
        ],
      ),
      body: _isLoading
          ? const SingleChildScrollView(child: ProductDetailsShimmer())
          : Padding(
              padding: const EdgeInsets.only(bottom: 100.0),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Main product image area
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusL),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 24,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 24),
                                  child: Center(
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: PageView.builder(
                                        key: _productImageKey,
                                        itemCount:
                                            widget.product.imageUrls.length,
                                        controller: PageController(
                                            initialPage: _currentImageIndex),
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentImageIndex = index;
                                          });
                                        },
                                        itemBuilder: (context, index) {
                                          return Image.network(
                                            widget.product.imageUrls.isNotEmpty
                                                ? widget
                                                    .product.imageUrls[index]
                                                : '',
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Icon(Icons.image,
                                                        color: Colors.grey[400],
                                                        size: 80),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                // Page indicator (bottom right)
                                if (widget.product.imageUrls.length > 1)
                                  Positioned(
                                    bottom: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEADBC8),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${_currentImageIndex + 1}/${widget.product.imageUrls.length}',
                                        style: const TextStyle(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          Container(
                            margin:
                                const EdgeInsets.all(AppDimensions.spacingS),
                            padding:
                                const EdgeInsets.all(AppDimensions.spacingS),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  AppDimensions.borderRadiusM),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Thumbnail row with background and scale effect
                                if (widget.product.imageUrls.length > 1)
                                  Container(
                                    color: const Color(0xFFF8F7F5),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: SizedBox(
                                      height: 70,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            widget.product.imageUrls.length,
                                        separatorBuilder: (_, __) =>
                                            const SizedBox(width: 18),
                                        itemBuilder: (context, index) {
                                          final isSelected =
                                              _currentImageIndex == index;
                                          return GestureDetector(
                                            onTapDown: (_) => setState(() =>
                                                _currentImageIndex = index),
                                            child: AnimatedScale(
                                              scale: isSelected ? 1.08 : 1.0,
                                              duration: const Duration(
                                                  milliseconds: 120),
                                              child: Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: isSelected
                                                      ? Border.all(
                                                          color: Colors.brown,
                                                          width: 2)
                                                      : null,
                                                  boxShadow: isSelected
                                                      ? [
                                                          BoxShadow(
                                                              color: Colors
                                                                  .brown
                                                                  .withOpacity(
                                                                      0.08),
                                                              blurRadius: 8,
                                                              offset:
                                                                  const Offset(
                                                                      0, 2))
                                                        ]
                                                      : [],
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    widget.product
                                                        .imageUrls[index],
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Icon(Icons.image,
                                                            color: Colors
                                                                .grey[400]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                // Divider between image and price/title
                                const SizedBox(height: 8),

                                Text(
                                  widget.product.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // Star rating row

                                // Section headers with all-caps and letter spacing
                                Text(
                                  'PRODUCT DETAILS',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${_getCategoryName()} Style',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: subTextColor,
                                  ),
                                ),

                                const SizedBox(height: AppDimensions.spacingS),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .2,
                                  child: Html(
                                    data: widget
                                            .product.shortDescription.isNotEmpty
                                        ? widget.product.shortDescription
                                        : widget.product.description,
                                  ),
                                ),
                                if (widget.product.description.isNotEmpty) ...[
                                  const SizedBox(
                                      height: AppDimensions.spacingXS),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                            'Product Description',
                                            style: theme.textTheme.titleLarge,
                                          ),
                                          content: SingleChildScrollView(
                                            child: Html(
                                                data:
                                                    widget.product.description),
                                          ),
                                          actions: [
                                            AppTextButton(
                                              text: 'Close',
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Read more',
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                if (sizes.isNotEmpty) ...[
                                  const SizedBox(
                                      height: AppDimensions.spacingL),
                                  Text(
                                    'Select Size',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: AppDimensions.spacingM),
                                  AppSizeSelector(
                                    sizes: sizes,
                                    selectedSize: _selectedSize,
                                    onSizeSelected: (size) {
                                      setState(() {
                                        _selectedSize = size;
                                      });
                                    },
                                  ),
                                ],
                                if (colors.isNotEmpty) ...[
                                  const SizedBox(
                                      height: AppDimensions.spacingL),
                                  Text(
                                    'Select Color${_selectedColor != null ? ' : $_selectedColor' : ''}',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: AppDimensions.spacingM),
                                  AppColorSelector(
                                    colors: colors,
                                    selectedColor: _selectedColor,
                                    onColorSelected: (color) {
                                      setState(() {
                                        _selectedColor = color;
                                      });
                                    },
                                  ),
                                ],
                                if (widget.product.attributes.isNotEmpty) ...[
                                  const SizedBox(
                                      height: AppDimensions.spacingL),
                                  AppProductAttributes(
                                    attributes: widget.product.attributes,
                                    excludeAttributes: const ['size', 'color'],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingL,
            vertical: AppDimensions.spacingL),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total Price',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: subTextColor,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingXS),
                    Text(
                      CurrencyFormatter.formatPrice(widget.product.price),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  //  height: 45,
                  child: AddToCartButton(
                    productId: widget.product.id,
                    name: widget.product.name,
                    imageUrl: widget.product.imageUrls.isNotEmpty
                        ? widget.product.imageUrls.first
                        : '',
                    price: widget.product.price,
                    isExpanded: true,
                    selectedColor: _selectedColor,
                    selectedSize: _selectedSize,
                    additionalAttributes: _getAdditionalAttributes(),
                    onAddedToCart: _runCartAnimation,
                    onPressed: () {
                      final sizes = _extractSizes();
                      if (sizes.isNotEmpty && _selectedSize == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a size'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return false;
                      }

                      final colors = _extractColors();
                      if (colors.isNotEmpty && _selectedColor == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a color'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        return false;
                      }

                      return true;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Particle effect widget that shows when an item reaches the cart
class CartParticleEffect extends StatefulWidget {
  final double centerX;
  final double centerY;
  final Color color;
  final VoidCallback onComplete;

  const CartParticleEffect({
    Key? key,
    required this.centerX,
    required this.centerY,
    required this.color,
    required this.onComplete,
  }) : super(key: key);

  @override
  State<CartParticleEffect> createState() => _CartParticleEffectState();
}

class _CartParticleEffectState extends State<CartParticleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final int _particleCount = 12;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Create particles
    for (int i = 0; i < _particleCount; i++) {
      final angle = (i / _particleCount) * 2 * math.pi;
      final speed = 2.0 + _random.nextDouble() * 3.0;
      final size = 2.0 + _random.nextDouble() * 5.0;
      final ttl =
          0.5 + _random.nextDouble() * 0.5; // time to live between 0.5-1s

      _particles.add(Particle(
        angle: angle,
        speed: speed,
        size: size,
        ttl: ttl,
        color: HSLColor.fromColor(widget.color)
            .withLightness(
                _random.nextDouble() * 0.4 + 0.6) // Randomize lightness
            .withSaturation(
                _random.nextDouble() * 0.3 + 0.7) // Randomize saturation
            .toColor()
            .withOpacity(0.8 + _random.nextDouble() * 0.2), // Randomize opacity
      ));
    }

    // Initialize animation controller
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    _controller.forward();
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
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            progress: _controller.value,
            centerX: widget.centerX,
            centerY: widget.centerY,
          ),
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height),
        );
      },
    );
  }
}

class Particle {
  final double angle;
  final double speed;
  final double size;
  final double ttl; // Time to live (0.0 to 1.0)
  final Color color;

  Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.ttl,
    required this.color,
  });
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  final double centerX;
  final double centerY;

  ParticlePainter({
    required this.particles,
    required this.progress,
    required this.centerX,
    required this.centerY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Calculate particle life - fade out as it gets older
      final particleProgress = math.min(1.0, progress / particle.ttl);
      if (particleProgress >= 1.0) continue;

      // Calculate position
      final distance = particle.speed * 80 * particleProgress;
      final dx = math.cos(particle.angle) * distance;
      final dy = math.sin(particle.angle) * distance;

      // Calculate opacity - start at 1.0 and fade to 0.0
      final opacity = math.max(0.0, 1.0 - (particleProgress * 1.2));

      // Calculate size - start small, grow, then shrink
      final sizeMultiplier = particleProgress < 0.2
          ? particleProgress / 0.2
          : 1.0 - ((particleProgress - 0.2) / 0.8);

      final paint = Paint()
        ..color = particle.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      // Draw the particle
      canvas.drawCircle(
        Offset(centerX + dx, centerY + dy),
        particle.size * sizeMultiplier,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}

// Favorite button with tap animation
class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;
  final Color iconColor;
  const AnimatedFavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onTap,
    required this.iconColor,
  });
  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
        lowerBound: 0.9,
        upperBound: 1.1,
        value: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: IconButton(
        icon: Icon(widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.iconColor),
        onPressed: _onTap,
        tooltip: 'Favorite',
      ),
    );
  }
}
