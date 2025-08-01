import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/favorite_item.dart';
import '../bloc/favorite_bloc.dart';
import '../../../../core/theme/app_theme_extension.dart';
import '../../../../core/utils/snackbar_utils.dart';

class FavoriteButton extends StatefulWidget {
  final int productId;
  final String name;
  final String imageUrl;
  final String price;
  final Color? iconColor;
  final String? tooltip;
  final bool showSnackbar;

  const FavoriteButton({
    super.key,
    required this.productId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.iconColor,
    this.tooltip,
    this.showSnackbar = true,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  void initState() {
    super.initState();
    context.read<FavoriteBloc>().add(CheckFavorite(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appTheme = theme.appThemeExtension;

    return BlocBuilder<FavoriteBloc, FavoriteState>(
      buildWhen: (previous, current) {
        if (previous is FavoritesLoaded && current is FavoritesLoaded) {
          return previous.favoriteStatus[widget.productId] !=
              current.favoriteStatus[widget.productId];
        }
        return true;
      },
      builder: (context, state) {
        if (state is FavoritesLoaded) {
          final isFavorite = state.favoriteStatus[widget.productId] ?? false;
          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite
                  ? theme.colorScheme.error
                  : widget.iconColor ?? theme.colorScheme.onSurface,
            ),
            tooltip: widget.tooltip ??
                (isFavorite ? 'Remove from Wishlist' : 'Add to Wishlist'),
            onPressed: () {
              if (isFavorite) {
                context.read<FavoriteBloc>().add(
                      RemoveFavorite(widget.productId),
                    );
                if (widget.showSnackbar) {
                  SnackbarUtils.showSuccess(context, 'Removed from wishlist');
                }
              } else {
                context.read<FavoriteBloc>().add(
                      AddFavorite(
                        FavoriteItem(
                          productId: widget.productId,
                          name: widget.name,
                          imageUrl: widget.imageUrl,
                          price: widget.price,
                        ),
                      ),
                    );
                if (widget.showSnackbar) {
                  SnackbarUtils.showSuccess(context, 'Added to wishlist');
                }
              }
            },
          );
        }
        return IconButton(
          icon: Icon(
            Icons.favorite_border,
            color: widget.iconColor ?? theme.colorScheme.onSurface,
          ),
          tooltip: widget.tooltip ?? 'Add to Wishlist',
          onPressed: null,
        );
      },
    );
  }
}
