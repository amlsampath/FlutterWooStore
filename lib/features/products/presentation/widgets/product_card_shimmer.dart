import 'package:flutter/material.dart';
import '../../../../core/widgets/app_loading_shimmer.dart';
import '../../../../core/theme/app_dimensions.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          AspectRatio(
            aspectRatio: AppDimensions.productCardImageAspectRatio,
            child: AppLoadingShimmer(
              height: double.infinity,
              borderRadius: AppDimensions.borderRadiusNone,
            ),
          ),
          // Content placeholder
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.spacingS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title placeholder
                  AppLoadingShimmer(
                    height: AppDimensions.textHeightTitle,
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                  SizedBox(height: AppDimensions.spacingS),
                  // Second line of title placeholder
                  AppLoadingShimmer(
                    height: AppDimensions.textHeightTitle,
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                  SizedBox(height: AppDimensions.spacingS),
                  // Price placeholder
                  AppLoadingShimmer(
                    height: AppDimensions.textHeightPrice,
                    width: AppDimensions.priceWidth,
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
