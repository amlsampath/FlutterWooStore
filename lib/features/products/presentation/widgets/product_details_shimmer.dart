import 'package:flutter/material.dart';
import '../../../../core/widgets/app_loading_shimmer.dart';
import '../../../../core/theme/app_dimensions.dart';

class ProductDetailsShimmer extends StatelessWidget {
  const ProductDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image placeholder
        const AspectRatio(
          aspectRatio: AppDimensions.productCardImageAspectRatio,
          child: AppLoadingShimmer(
            height: double.infinity,
            borderRadius: AppDimensions.borderRadiusNone,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title placeholder
              const AppLoadingShimmer(
                width: double.infinity,
                height: AppDimensions.textHeightTitle * 2,
                borderRadius: AppDimensions.borderRadiusS,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              // Price placeholder
              const AppLoadingShimmer(
                width: AppDimensions.priceWidth * 1.5,
                height: AppDimensions.textHeightPrice,
                borderRadius: AppDimensions.borderRadiusS,
              ),
              const SizedBox(height: AppDimensions.spacingL),
              // Description title placeholder
              const AppLoadingShimmer(
                width: AppDimensions.priceWidth,
                height: AppDimensions.textHeightTitle,
                borderRadius: AppDimensions.borderRadiusS,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              // Description lines
              ...List.generate(
                4,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.spacingS),
                  child: AppLoadingShimmer(
                    width: double.infinity,
                    height: AppDimensions.textHeightTitle,
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              // Specifications title placeholder
              const AppLoadingShimmer(
                width: AppDimensions.priceWidth * 1.2,
                height: AppDimensions.textHeightTitle,
                borderRadius: AppDimensions.borderRadiusS,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              // Specification lines
              ...List.generate(
                3,
                (index) => const Padding(
                  padding: EdgeInsets.only(bottom: AppDimensions.spacingS),
                  child: AppLoadingShimmer(
                    width: double.infinity,
                    height: AppDimensions.textHeightTitle,
                    borderRadius: AppDimensions.borderRadiusS,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
