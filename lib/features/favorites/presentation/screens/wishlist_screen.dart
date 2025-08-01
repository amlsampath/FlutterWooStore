import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/favorite_bloc.dart';
import '../../domain/entities/favorite_item.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_elevated_button.dart';
import '../../../../core/widgets/error_text.dart';
import '../../../../core/widgets/empty_state_message.dart';
import '../../../../core/widgets/app_confirmation_dialog.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../../core/widgets/app_header.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorites when screen initializes
    context.read<FavoriteBloc>().add(LoadFavorites());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          const AppHeader(
            title: 'Wishlist',
          ),
          Expanded(
            child: BlocBuilder<FavoriteBloc, FavoriteState>(
              builder: (context, state) {
                if (state is FavoriteLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is FavoriteError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: AppDimensions.spacingM),
                        ErrorText(text: state.message),
                        const SizedBox(height: AppDimensions.spacingM),
                        AppElevatedButton(
                          text: 'Retry',
                          onPressed: () {
                            context.read<FavoriteBloc>().add(LoadFavorites());
                          },
                          minimumSize:
                              const Size(120, AppDimensions.buttonHeightM),
                        ),
                      ],
                    ),
                  );
                } else if (state is FavoritesLoaded) {
                  if (state.items.isEmpty) {
                    return EmptyStateMessage(
                      message: 'Your wishlist is empty',
                      icon: Icons.favorite_outline,
                      actionLabel: 'Start Shopping',
                      onActionPressed: () => context.go('/products'),
                    );
                  } else {
                    return _buildWishlistContent(context, state.items);
                  }
                }
                return EmptyStateMessage(
                  message: 'Your wishlist is empty',
                  icon: Icons.favorite_outline,
                  actionLabel: 'Start Shopping',
                  onActionPressed: () => context.go('/products'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppConfirmationDialog(
        title: 'Clear Wishlist',
        message:
            'Are you sure you want to remove all items from your wishlist?',
        confirmLabel: 'Clear All',
        confirmColor: Theme.of(context).colorScheme.error,
        icon: Icons.delete_outline,
        iconColor: Theme.of(context).colorScheme.error,
        onConfirm: () {
          context.read<FavoriteBloc>().add(ClearAllFavorites());
          SnackbarUtils.showSuccess(context, 'Wishlist cleared');
        },
      ),
    );
  }

  Widget _buildWishlistContent(BuildContext context, List<FavoriteItem> items) {
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.imageUrl,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 54,
                    height: 54,
                    color: Colors.grey[200],
                    child: Icon(Icons.image, color: Colors.grey[400]),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      CurrencyFormatter.formatPrice(item.price),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 18),
                        SizedBox(width: 4),
                        Text('4.9 (100+)',
                            style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline,
                    color: Color(0xFFD32F2F), size: 28),
                onPressed: () {
                  context
                      .read<FavoriteBloc>()
                      .add(RemoveFavorite(item.productId));
                  SnackbarUtils.showSuccess(
                      context, 'Item removed from wishlist');
                },
                splashRadius: 24,
              ),
            ],
          ),
        );
      },
    );
  }
}

// Simple caution stripe painter with alternating black and yellow
class CautionStripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final yellowPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final blackPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // Fill background yellow
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      yellowPaint,
    );

    // Draw diagonal black stripes
    final stripeWidth = size.height * 0.8; // Wider stripes
    final gap = size.height * 0.5; // Spacing between stripes

    // Draw multiple diagonal stripes across the width
    for (double x = -size.height; x < size.width + size.height; x += gap) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + stripeWidth, 0)
        ..lineTo(x + stripeWidth + size.height, size.height)
        ..lineTo(x + size.height, size.height)
        ..close();

      canvas.drawPath(path, blackPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
