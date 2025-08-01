import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'interceptors/auth_interceptor.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        )) {
    dio.interceptors.add(
      AuthInterceptor(
        consumerKey: AppConfig.consumerKey,
        consumerSecret: AppConfig.consumerSecret,
      ),
    );
  }
}
