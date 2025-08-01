import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/products/domain/entities/product.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/products/presentation/screens/product_list_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/best_sellers_screen.dart';
import '../../features/home/presentation/screens/new_arrivals_screen.dart';
import '../../features/home/presentation/screens/trending_now_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/favorites/presentation/screens/wishlist_screen.dart';
import '../../features/account/presentation/screens/account_screen.dart';
import '../../features/account/presentation/screens/profile_screen.dart';
import '../../features/account/presentation/screens/orders_screen.dart';
import '../../features/account/presentation/screens/order_details_screen.dart';
import '../../features/checkout/presentation/screens/checkout_screen.dart';
import '../../features/checkout/presentation/screens/payment_screen.dart';
import '../../features/shipping/presentation/screens/shipping_selection_screen.dart';
import '../../features/checkout/presentation/screens/order_summary_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/welcome/presentation/screens/welcome_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/settings/presentation/screens/theme_settings_screen.dart';
import '../../features/categories/presentation/screens/category_products_screen.dart';
import '../widgets/bottom_navigation.dart';
import '../services/settings_service.dart';
import '../../features/checkout/presentation/screens/billing_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/categories/presentation/bloc/category_product_bloc.dart';
import 'package:provider/provider.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import 'package:ecommerce_app/features/categories/presentation/screens/category_all_screen.dart';

// This redirects to welcome screen for first-time users
Future<String?> checkFirstLaunch() async {
  try {
    final settingsService = GetIt.instance<SettingsService>();
    final isFirstLaunch = await settingsService.isFirstLaunch();
    if (isFirstLaunch) {
      return '/welcome';
    }
    return null;
  } catch (e) {
    print('Error checking first launch: $e');
    return null;
  }
}

final router = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.path;

        // Only show bottom nav on these 5 specific pages
        final showBottomNav = location == '/home' ||
            location == '/products' ||
            location == '/cart' ||
            location == '/wishlist' ||
            location == '/profile';

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              child,
              if (showBottomNav)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(child: BottomNavigation()),
                ),
            ],
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/best-sellers',
          builder: (context, state) => const BestSellersScreen(),
        ),
        GoRoute(
          path: '/new-arrivals',
          builder: (context, state) => const NewArrivalsScreen(),
        ),
        GoRoute(
          path: '/trending-now',
          builder: (context, state) => const TrendingNowScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) =>
              SearchScreen(extraParams: state.extra as Map<String, dynamic>?),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => Provider<AuthLocalDataSource>.value(
            value: GetIt.I<AuthLocalDataSource>(),
            child: const CartScreen(),
          ),
        ),
        GoRoute(
          path: '/wishlist',
          builder: (context, state) => const WishlistScreen(),
        ),
        GoRoute(
          path: '/customer-profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const AccountScreen(), //ProfileScreen(),
        ),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersScreen(),
        ),
        GoRoute(
          path: '/orders/:id',
          builder: (context, state) {
            final orderId = int.parse(state.pathParameters['id'] ?? '0');
            return OrderDetailsScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductListScreen(),
        ),
        GoRoute(
          path: '/product/:id',
          builder: (context, state) {
            final product = state.extra as Product;
            return ProductDetailsScreen(product: product);
          },
        ),
        GoRoute(
          path: '/checkout',
          builder: (context, state) => const CheckoutScreen(),
        ),
        GoRoute(
          path: '/checkout/billing',
          builder: (context, state) => const BillingScreen(),
        ),
        GoRoute(
          path: '/checkout/payment',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            final shippingMethodId = extra?['shippingMethodId'] as String?;
            if (shippingMethodId == null) {
              context.go('/shipping');
              return const SizedBox(); // Placeholder while redirecting
            }
            return PaymentScreen(shippingMethodId: shippingMethodId);
          },
        ),
        GoRoute(
          path: '/checkout/summary',
          builder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            if (extra == null ||
                extra['orderDetails'] == null ||
                extra['billingInfo'] == null) {
              context.go('/checkout');
              return const SizedBox(); // Placeholder while redirecting
            }
            return OrderSummaryScreen(
              orderDetails: extra['orderDetails'] as Map<String, dynamic>,
              billingInfo: extra['billingInfo'],
            );
          },
        ),
        GoRoute(
          path: '/shipping',
          builder: (context, state) => const ShippingSelectionScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/forgot-password',
          builder: (context, state) => const ForgotPasswordScreen(),
        ),
        // Settings Routes
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: '/settings/theme',
          builder: (context, state) => const ThemeSettingsScreen(),
        ),
        GoRoute(
          path: '/category/:id',
          builder: (context, state) {
            final categoryId = state.pathParameters['id'];
            final extra = state.extra as Map<String, dynamic>?;
            final categoryName = extra?['name'] as String? ?? 'Category';
            return MultiBlocProvider(
              providers: [
                RepositoryProvider<ProductRepository>.value(
                  value: GetIt.I<ProductRepository>(),
                ),
                BlocProvider<CategoryProductBloc>(
                  create: (context) => CategoryProductBloc(
                    repository: context.read<ProductRepository>(),
                  ),
                ),
              ],
              child: CategoryProductsScreen(
                categoryId: categoryId,
                categoryName: categoryName,
              ),
            );
          },
        ),
        GoRoute(
          path: '/categories/all',
          builder: (context, state) => const CategoryAllScreen(),
        ),
      ],
    ),
  ],
);
