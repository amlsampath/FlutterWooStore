import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_colors.dart';

class ProductCardShimmer extends StatelessWidget {
  final bool isDarkMode;
  final double height;
  final double borderRadius;
  const ProductCardShimmer({
    super.key,
    this.isDarkMode = false,
    this.height = 130,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: isDarkMode
          ? AppColors.primary.withOpacity(0.5)
          : AppColors.secondary.withOpacity(0.2),
      highlightColor: isDarkMode
          ? AppColors.secondary.withOpacity(0.5)
          : AppColors.primary.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    topRight: Radius.circular(borderRadius),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: 100,
                      color: AppColors.cardBackground,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      height: 12,
                      width: 60,
                      color: AppColors.cardBackground,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
