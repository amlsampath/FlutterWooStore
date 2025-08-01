import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class AppImageGallery extends StatefulWidget {
  final List<String> imageUrls;
  final double aspectRatio;
  final double thumbnailSize;
  final double thumbnailSpacing;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Widget? placeholder;
  final Widget? errorWidget;

  const AppImageGallery({
    super.key,
    required this.imageUrls,
    this.aspectRatio = 1,
    this.thumbnailSize = 60,
    this.thumbnailSpacing = 8,
    this.borderRadius,
    this.backgroundColor,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.placeholder,
    this.errorWidget,
  });

  @override
  State<AppImageGallery> createState() => _AppImageGalleryState();
}

class _AppImageGalleryState extends State<AppImageGallery> {
  int _currentImageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final backgroundColor = widget.backgroundColor ??
        (isDarkMode ? AppColors.background : AppColors.surface);
    final shimmerBaseColor = widget.shimmerBaseColor ??
        (isDarkMode ? AppColors.surface : AppColors.surface);
    final shimmerHighlightColor = widget.shimmerHighlightColor ??
        (isDarkMode ? AppColors.background : AppColors.surface);

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(AppDimensions.spacingL),
          child: ClipRRect(
            borderRadius: widget.borderRadius ??
                BorderRadius.circular(AppDimensions.borderRadiusL),
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: Container(
                color: backgroundColor,
                child: widget.imageUrls.isEmpty
                    ? const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 100,
                          color: AppColors.textSecondary,
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentImageIndex = index;
                          });
                        },
                        itemCount: widget.imageUrls.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: widget.imageUrls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: shimmerBaseColor,
                              highlightColor: shimmerHighlightColor,
                              child: Container(color: AppColors.surface),
                            ),
                            errorWidget: (context, url, error) =>
                                widget.errorWidget ??
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.error,
                                ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
        if (widget.imageUrls.length > 1)
          SizedBox(
            height: widget.thumbnailSize + widget.thumbnailSpacing * 2,
            child: ListView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingS,
                vertical: widget.thumbnailSpacing,
              ),
              scrollDirection: Axis.horizontal,
              itemCount: widget.imageUrls.length,
              itemBuilder: (context, index) {
                final isSelected = _currentImageIndex == index;
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: widget.thumbnailSize,
                    margin: EdgeInsets.only(right: widget.thumbnailSpacing),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadiusS),
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.borderRadiusS),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrls[index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: shimmerBaseColor,
                          highlightColor: shimmerHighlightColor,
                          child: Container(color: AppColors.surface),
                        ),
                        errorWidget: (context, url, error) =>
                            widget.errorWidget ??
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.error,
                            ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
