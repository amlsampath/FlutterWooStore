import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service_locator.dart';
import 'core/config/app_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_theme_extension.dart';
import 'core/theme/theme_cubit.dart';
import 'core/services/app_initialization_service.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/cart/data/models/cart_item_model.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/favorites/data/models/favorite_item_model.dart';
import 'features/favorites/presentation/bloc/favorite_bloc.dart';
import 'features/categories/presentation/bloc/category_bloc.dart';
import 'features/checkout/data/models/billing_info_model.dart';
import 'features/checkout/data/models/shipping_info_model.dart';
import 'features/checkout/presentation/bloc/checkout_bloc.dart';
import 'features/shipping/presentation/bloc/shipping_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/account/presentation/bloc/profile_bloc.dart';
import 'features/checkout/presentation/bloc/shipping_address_bloc.dart';
import 'features/checkout/presentation/bloc/billing_address_bloc.dart';
import 'package:provider/provider.dart';
import 'features/home/presentation/bloc/best_sellers_bloc.dart';
import 'features/home/presentation/bloc/new_arrivals_bloc.dart';
import 'features/home/presentation/bloc/trending_now_bloc.dart';
import 'features/browsing_history/presentation/cubit/browsing_history_cubit.dart';
import 'features/search/data/models/product_search_model.dart';

final getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize environment variables
    await AppConfig.initialize();

    // Validate all required environment variables
    AppConfig.validateEnvironment();

    // Initialize Hive
    await Hive.initFlutter();
    Hive.registerAdapter(CartItemModelAdapter());
    Hive.registerAdapter(FavoriteItemModelAdapter());
    Hive.registerAdapter(BillingInfoModelAdapter());
    Hive.registerAdapter(ShippingInfoModelAdapter());
    Hive.registerAdapter(ProductSearchModelAdapter());

    await Hive.openBox<CartItemModel>('cart');
    await Hive.openBox<FavoriteItemModel>('favorites');
    await Hive.openBox<BillingInfoModel>('billing_info');
    await Hive.openBox<ShippingInfoModel>('shipping_info');
    await Hive.openBox<ProductSearchModel>('product_search');

    // Initialize SharedPreferences for theme storage
    await SharedPreferences.getInstance();

    // Initialize all dependencies
    await initializeDependencies();

    // Initialize app data
    await sl<AppInitializationService>().initialize();
    print('App initialization completed successfully');

    runApp(
      MultiBlocProvider(
        providers: [
          Provider<ProductRepository>(
            create: (_) => sl<ProductRepository>(),
          ),
          BlocProvider(create: (context) => sl<BestSellersBloc>()),
          BlocProvider(create: (context) => sl<NewArrivalsBloc>()),
          BlocProvider(create: (context) => sl<TrendingNowBloc>()),
          BlocProvider(create: (context) => sl<ProductBloc>()),
          BlocProvider(create: (context) => sl<CategoryBloc>()),
          BlocProvider(create: (context) => sl<CheckoutBloc>()),
          BlocProvider(create: (context) => sl<ShippingBloc>()),
          BlocProvider(create: (context) => sl<CartBloc>()),
          BlocProvider(create: (context) => sl<FavoriteBloc>()),
          BlocProvider(create: (context) => sl<AuthBloc>()),
          BlocProvider(create: (context) => sl<SearchBloc>()),
          BlocProvider(create: (_) => ThemeCubit()..toggleTheme(true)),
          BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
          BlocProvider(create: (context) => sl<ShippingAddressBloc>()),
          BlocProvider(create: (context) => sl<BillingAddressBloc>()),
          BlocProvider(
            create: (_) => sl<BrowsingHistoryCubit>()..loadBrowsingHistory(),
          ),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Error during app initialization: $e');
    // You might want to show an error screen here
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Error initializing app: $e'),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'E-Commerce App',
          theme: AppTheme.lightTheme.copyWith(
            extensions: [AppThemeExtension.light],
          ),
          darkTheme: AppTheme.darkTheme.copyWith(
            extensions: [AppThemeExtension.dark],
          ),
          themeMode: themeMode,
          routerConfig: router,
        );
      },
    );
  }
}
