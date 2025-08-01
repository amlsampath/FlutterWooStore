import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppLoadingShimmer extends StatelessWidget {
  final bool isDarkMode;
  final Color? baseColor;
  final Color? highlightColor;
  final double borderRadius;
  final double height;
  final double width;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const AppLoadingShimmer({
    super.key,
    this.isDarkMode = false,
    this.baseColor,
    this.highlightColor,
    this.borderRadius = 8,
    this.height = 16,
    this.width = double.infinity,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBaseColor = baseColor ??
        (isDarkMode ? theme.colorScheme.surfaceContainerHighest : Colors.grey[300]!);
    final defaultHighlightColor = highlightColor ??
        (isDarkMode ? theme.colorScheme.surface : Colors.grey[100]!);

    return Shimmer.fromColors(
      baseColor: defaultBaseColor,
      highlightColor: defaultHighlightColor,
      child: Container(
        margin: margin,
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: defaultBaseColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class AppLoadingShimmerList extends StatelessWidget {
  final int itemCount;
  final bool isDarkMode;
  final Color? baseColor;
  final Color? highlightColor;
  final double itemHeight;
  final double itemWidth;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final Axis direction;
  final double borderRadius;

  const AppLoadingShimmerList({
    super.key,
    this.itemCount = 5,
    this.isDarkMode = false,
    this.baseColor,
    this.highlightColor,
    this.itemHeight = 16,
    this.itemWidth = double.infinity,
    this.spacing = 8,
    this.padding,
    this.direction = Axis.vertical,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: direction == Axis.vertical
          ? Column(
              children: List.generate(
                itemCount,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index < itemCount - 1 ? spacing : 0,
                  ),
                  child: AppLoadingShimmer(
                    isDarkMode: isDarkMode,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    height: itemHeight,
                    width: itemWidth,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
            )
          : Row(
              children: List.generate(
                itemCount,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    right: index < itemCount - 1 ? spacing : 0,
                  ),
                  child: AppLoadingShimmer(
                    isDarkMode: isDarkMode,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    height: itemHeight,
                    width: itemWidth,
                    borderRadius: borderRadius,
                  ),
                ),
              ),
            ),
    );
  }
}
