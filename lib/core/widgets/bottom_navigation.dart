import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ecommerce_app/core/theme/app_colors.dart';
import 'package:ecommerce_app/features/cart/presentation/widgets/cart_button.dart';

class BottomNavigation extends StatelessWidget {
  final GlobalKey cartIconKey = GlobalKey();

  BottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    // Colors based on theme
    final backgroundColor =
        isDarkMode ? const Color.fromARGB(255, 26, 26, 26) : Colors.white;
    const selectedItemColor = Colors.black; // match design
    const unselectedItemColor = AppColors.textPrimary;

    return Container(
      // margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12, top: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        //  borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildSvgNavItem(
            index: 0,
            currentIndex: selectedIndex,
            iconName: 'home',
            label: 'Home',
            selectedColor: selectedItemColor,
            unselectedColor: unselectedItemColor,
            onTap: (index) => _onItemTapped(index, context),
          ),
          _buildSvgNavItem(
            index: 1,
            currentIndex: selectedIndex,
            iconName: 'products',
            label: 'Products',
            selectedColor: selectedItemColor,
            unselectedColor: unselectedItemColor,
            onTap: (index) => _onItemTapped(index, context),
          ),
          Stack(
            children: [
              _buildSvgNavItem(
                index: 2,
                currentIndex: selectedIndex,
                iconName: 'cart',
                label: 'Cart',
                selectedColor: selectedItemColor,
                unselectedColor: unselectedItemColor,
                onTap: (index) => _onItemTapped(index, context),
              ),
              Positioned(
                //top: 5,
                right: 10,
                bottom: 70,
                child: CartButton(
                  key: cartIconKey,
                  isIconRequired: false,
                  badgeColor: Colors.red.withOpacity(0.8),
                  badgeSize: 20,
                ),
              ),
            ],
          ),
          _buildSvgNavItem(
            index: 3,
            currentIndex: selectedIndex,
            iconName: 'wishlist',
            label: 'Wishlist',
            selectedColor: selectedItemColor,
            unselectedColor: unselectedItemColor,
            onTap: (index) => _onItemTapped(index, context),
          ),
          _buildSvgNavItem(
            index: 4,
            currentIndex: selectedIndex,
            iconName: 'profile',
            label: 'Profile',
            selectedColor: selectedItemColor,
            unselectedColor: unselectedItemColor,
            onTap: (index) => _onItemTapped(index, context),
          ),
        ],
      ),
    );
  }

  Widget _buildSvgNavItem({
    required int index,
    required int currentIndex,
    required String iconName,
    required String label,
    required Color selectedColor,
    required Color unselectedColor,
    required Function(int) onTap,
  }) {
    final isSelected = currentIndex == index;
    final iconPath = isSelected
        ? 'assets/menu/selected/$iconName.svg'
        : 'assets/menu/$iconName.svg';
    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              color: isSelected ? selectedColor : unselectedColor,
              width: 45,
              height: 45,
            ),
            // const SizedBox(height: 4),
            // Text(
            //   label,
            //   style: TextStyle(
            //     fontSize: 12,
            //     color: isSelected ? selectedColor : unselectedColor,
            //     fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/home') return 0;
    if (location == '/products') return 1;
    if (location == '/cart') return 2;
    if (location == '/wishlist') return 3;
    if (location == '/profile') return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/products');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/wishlist');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
