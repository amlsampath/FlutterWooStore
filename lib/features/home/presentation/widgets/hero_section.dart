import 'package:flutter/material.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/core/widgets/app_search_bar.dart';

class HeroSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final String imagePath;
  final VoidCallback onButtonPressed;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;

  const HeroSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.imagePath,
    required this.onButtonPressed,
    required this.onSearchTap,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          height: 260,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                Color(0xFF181A20),
              ],
            ),
          ),
        ),
        // Larger, softer glow behind image
        Positioned(
          right: 20,
          top: 60,
          child: Container(
            width: 210,
            height: 210,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.13),
                  blurRadius: 90,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
        ),
        // Image overlay
        Positioned(
          right: 0,
          top: 54,
          child: SizedBox(
            width: 230,
            height: 230,
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
            ),
          ),
        ),
        // Search bar and filter button
        Positioned(
          top: 40,
          left: 10,
          right: 10,
          child: AppHeaderSearchBar(
            hintText: 'Search products...',
            onSearchTap: onSearchTap,
            onFilterTap: onFilterTap,
          ),
        ),
        // Headline, subtitle, and button
        Positioned(
          left: 32,
          top: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w900,
                  fontSize: 25,
                  letterSpacing: 9,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 5,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD1A05A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    elevation: 0,
                  ),
                  onPressed: onButtonPressed,
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 2,
                    ),
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
