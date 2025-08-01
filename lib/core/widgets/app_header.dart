import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  final double height;
  final List<Widget>? actions;
  final Widget? widget;

  const AppHeader({
    super.key,
    required this.title,
    this.height = 160,
    this.actions,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Background image
        Container(
          height: height,
          width: double.infinity,
          color: AppColors.primary,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Image.asset(
            'assets/images/header_bg.png',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: widget ??
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
