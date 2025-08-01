import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_dimensions.dart';

class AppShimmer extends StatelessWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor:
          baseColor ?? (isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
      highlightColor: highlightColor ??
          (isDarkMode ? Colors.grey[700]! : Colors.grey[100]!),
      enabled: enabled,
      child: child,
    );
  }
}

class AppShimmerCircle extends StatelessWidget {
  final double size;
  final Color? color;

  const AppShimmerCircle({
    super.key,
    this.size = 60,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppShimmer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color ?? (isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class AppShimmerText extends StatelessWidget {
  final double height;
  final double width;
  final BorderRadius? borderRadius;

  const AppShimmerText({
    super.key,
    this.height = 12,
    this.width = 50,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return AppShimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
          borderRadius: borderRadius ??
              BorderRadius.circular(AppDimensions.borderRadiusS),
        ),
      ),
    );
  }
}

class AppShimmerCategory extends StatelessWidget {
  const AppShimmerCategory({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: AppDimensions.spacingM),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppShimmerCircle(),
          SizedBox(height: AppDimensions.spacingS),
          AppShimmerText(),
        ],
      ),
    );
  }
}

class AppShimmerCategoryList extends StatelessWidget {
  final int itemCount;
  final double height;

  const AppShimmerCategoryList({
    super.key,
    this.itemCount = 6,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) => const AppShimmerCategory(),
      ),
    );
  }
}
