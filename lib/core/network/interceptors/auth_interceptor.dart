import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final String consumerKey;
  final String consumerSecret;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthInterceptor({
    required this.consumerKey,
    required this.consumerSecret,
  });

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip authentication for JWT endpoints
    if (options.path.contains('jwt-auth')) {
      return handler.next(options);
    }

    // Get JWT token for authenticated requests
    final tokenJson = await _storage.read(key: 'auth_token');
    if (tokenJson != null && options.path.contains('/wp-json/wp/v2/users/me')) {
      try {
        final tokenData = json.decode(tokenJson) as Map<String, dynamic>;
        final token = tokenData['token'] as String;
        options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      } catch (e) {
        print('Error parsing stored token: $e');
        // If token parsing fails, fall back to WooCommerce auth
      }
    }

    // Use WooCommerce API authentication
    final credentials = '$consumerKey:$consumerSecret';
    final base64Str = base64Encode(utf8.encode(credentials));
    options.headers['Authorization'] = 'Basic $base64Str';
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle unauthorized error
      return handler.reject(err);
    }
    return handler.next(err);
  }
}
