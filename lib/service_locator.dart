import 'package:get_it/get_it.dart';
import 'features/products/data/datasources/product_remote_data_source.dart';
import 'core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/checkout/domain/repositories/checkout_repository.dart';
import 'features/checkout/domain/repositories/payment_repository.dart';
import 'features/checkout/data/repositories/checkout_repository_impl.dart';
import 'features/checkout/data/repositories/payment_repository_impl.dart';
import 'features/checkout/data/services/payhere_service.dart';
import 'features/checkout/presentation/bloc/checkout_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/checkout/data/datasources/checkout_remote_data_source.dart';
import 'features/checkout/data/datasources/payment_remote_data_source.dart';
import 'package:hive/hive.dart';
import 'features/checkout/data/models/billing_info_model.dart';
import 'features/checkout/data/models/shipping_info_model.dart';
import 'features/cart/data/models/cart_item_model.dart';
import 'features/favorites/data/models/favorite_item_model.dart';
import 'features/products/domain/repositories/product_repository.dart';
import 'features/products/data/repositories/product_repository_impl.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'core/services/settings_service.dart';
import 'core/config/app_config.dart';
import 'features/search/data/datasources/product_search_local_data_source.dart';
import 'features/search/data/models/product_search_model.dart';
import 'core/services/app_initialization_service.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/categories/presentation/bloc/category_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/favorites/presentation/bloc/favorite_bloc.dart';
import 'features/home/presentation/bloc/best_sellers_bloc.dart';
import 'features/home/presentation/bloc/new_arrivals_bloc.dart';
import 'features/home/presentation/bloc/trending_now_bloc.dart';
import 'features/shipping/presentation/bloc/shipping_bloc.dart';
import 'features/account/presentation/bloc/profile_bloc.dart';
import 'features/checkout/presentation/bloc/shipping_address_bloc.dart';
import 'features/checkout/presentation/bloc/billing_address_bloc.dart';
import 'features/categories/domain/repositories/category_repository.dart';
import 'features/categories/data/repositories/category_repository_impl.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/data/repositories/cart_repository_impl.dart';
import 'features/favorites/domain/repositories/favorite_repository.dart';
import 'features/favorites/data/repositories/favorite_repository_impl.dart';
import 'features/shipping/domain/repositories/shipping_repository.dart';
import 'features/shipping/data/repositories/shipping_repository_impl.dart';
import 'features/categories/data/datasources/category_remote_data_source.dart';
import 'features/shipping/data/datasources/shipping_remote_data_source.dart';
import 'core/theme/app_theme_manager.dart';
import 'features/browsing_history/domain/usecases/add_product_to_history_usecase.dart';
import 'features/browsing_history/domain/usecases/get_browsing_history_usecase.dart';
import 'features/browsing_history/data/repositories/browsing_history_repository_impl.dart';
import 'features/browsing_history/data/datasources/browsing_history_local_data_source.dart';
import 'features/browsing_history/domain/repositories/browsing_history_repository.dart';
import 'features/browsing_history/presentation/cubit/browsing_history_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Core
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Dio setup with interceptors
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final storage = sl<FlutterSecureStorage>();
          final token = await storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    return dio;
  });

  // Settings Service
  sl.registerLazySingleton<SettingsService>(
    () => SettingsService(
      dio: sl<Dio>(),
      baseUrl: AppConfig.baseUrl,
    ),
  );

  // Theme Manager
  sl.registerLazySingleton<ThemeManager>(
    () => ThemeManager(sl<SharedPreferences>())..add(InitializeTheme()),
  );

  // Data Sources
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  sl.registerLazySingleton<CheckoutRemoteDataSource>(
    () => CheckoutRemoteDataSourceImpl(
      dio: sl<DioClient>().dio,
      baseUrl: AppConfig.baseUrl,
    ),
  );

  sl.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(
      dio: sl<Dio>(),
      baseUrl: AppConfig.baseUrl,
      merchantId: AppConfig.payHereMerchantId,
      merchantSecret: AppConfig.payHereMerchantSecret,
      isSandbox: AppConfig.payHereIsSandbox,
    ),
  );

  sl.registerLazySingleton<ShippingRemoteDataSource>(
    () => ShippingRemoteDataSourceImpl(dioClient: sl<DioClient>()),
  );

  // Auth Feature
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      storage: sl(),
      billingBox: sl<Box<BillingInfoModel>>(),
      shippingBox: sl<Box<ShippingInfoModel>>(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      dioClient: sl<DioClient>(),
      baseUrl: AppConfig.baseUrl,
    ),
  );

  // Hive Boxes
  sl.registerLazySingleton<Box<BillingInfoModel>>(
    () => Hive.box<BillingInfoModel>('billing_info'),
  );

  sl.registerLazySingleton<Box<ShippingInfoModel>>(
    () => Hive.box<ShippingInfoModel>('shipping_info'),
  );

  sl.registerLazySingleton<Box<CartItemModel>>(
    () => Hive.box<CartItemModel>('cart'),
  );

  sl.registerLazySingleton<Box<FavoriteItemModel>>(
    () => Hive.box<FavoriteItemModel>('favorites'),
  );

  sl.registerLazySingleton<Box<ProductSearchModel>>(
    () => Hive.box<ProductSearchModel>('product_search'),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl<ProductRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(
      remoteDataSource: sl(),
      billingBox: sl(),
      shippingBox: sl(),
      cartBox: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(sl<Box<CartItemModel>>()),
  );

  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(sl<Box<FavoriteItemModel>>()),
  );

  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(
      remoteDataSource: sl<CategoryRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<ShippingRepository>(
    () => ShippingRepositoryImpl(
      remoteDataSource: sl<ShippingRemoteDataSource>(),
    ),
  );

  // Product Search
  sl.registerLazySingleton<ProductSearchLocalDataSource>(
    () => ProductSearchLocalDataSourceImpl(sl<Box<ProductSearchModel>>()),
  );

  // Browsing History
  sl.registerLazySingleton<BrowsingHistoryLocalDataSource>(
    () => BrowsingHistoryLocalDataSourceImpl(
        Future.value(sl<SharedPreferences>())),
  );

  sl.registerLazySingleton<BrowsingHistoryRepository>(
    () => BrowsingHistoryRepositoryImpl(
      localDataSource: sl<BrowsingHistoryLocalDataSource>(),
    ),
  );

  sl.registerLazySingleton<AddProductToHistoryUseCase>(
    () => AddProductToHistoryUseCase(sl<BrowsingHistoryRepository>()),
  );

  sl.registerLazySingleton<GetBrowsingHistoryUseCase>(
    () => GetBrowsingHistoryUseCase(sl<BrowsingHistoryRepository>()),
  );

  // Services
  sl.registerLazySingleton<PayHereService>(
    () => PayHereService(),
  );

  sl.registerLazySingleton<AppInitializationService>(
    () => AppInitializationService(
      productRepository: sl<ProductRepository>(),
      localDataSource: sl<ProductSearchLocalDataSource>(),
      productSearchBox: sl<Box<ProductSearchModel>>(),
    ),
  );

  // Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      repository: sl<AuthRepository>(),
      checkoutRepository: sl<CheckoutRepository>(),
    ),
  );

  sl.registerFactory<CheckoutBloc>(
    () => CheckoutBloc(
      repository: sl(),
      paymentRepository: sl(),
      payHereService: sl(),
      authRepository: sl(),
    ),
  );

  sl.registerFactory<SearchBloc>(
    () => SearchBloc(
      productRepository: sl<ProductRepository>(),
      localDataSource: sl<ProductSearchLocalDataSource>(),
    ),
  );

  sl.registerFactory<ProductBloc>(
    () => ProductBloc(repository: sl<ProductRepository>()),
  );

  sl.registerFactory<CategoryBloc>(
    () => CategoryBloc(repository: sl<CategoryRepository>()),
  );

  sl.registerFactory<CartBloc>(
    () => CartBloc(sl<CartRepository>()),
  );

  sl.registerFactory<FavoriteBloc>(
    () => FavoriteBloc(sl<FavoriteRepository>()),
  );

  sl.registerFactory<BestSellersBloc>(
    () => BestSellersBloc(repository: sl<ProductRepository>()),
  );

  sl.registerFactory<NewArrivalsBloc>(
    () => NewArrivalsBloc(repository: sl<ProductRepository>()),
  );

  sl.registerFactory<TrendingNowBloc>(
    () => TrendingNowBloc(repository: sl<ProductRepository>()),
  );

  sl.registerFactory<ShippingBloc>(
    () => ShippingBloc(repository: sl<ShippingRepository>()),
  );

  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      authRepository: sl<AuthRepository>(),
      checkoutRepository: sl<CheckoutRepository>(),
    ),
  );

  sl.registerFactory<ShippingAddressBloc>(
    () => ShippingAddressBloc(repository: sl<CheckoutRepository>()),
  );

  sl.registerFactory<BillingAddressBloc>(
    () => BillingAddressBloc(repository: sl<CheckoutRepository>()),
  );

  sl.registerFactory<BrowsingHistoryCubit>(
    () => BrowsingHistoryCubit(
      addProductToHistoryUseCase: sl<AddProductToHistoryUseCase>(),
      getBrowsingHistoryUseCase: sl<GetBrowsingHistoryUseCase>(),
    ),
  );
}
