// import 'package:dio/dio.dart';
// import 'dart:convert';

// class AuthInterceptor extends Interceptor {
//   final String consumerKey;
//   final String consumerSecret;

//   AuthInterceptor({
//     required this.consumerKey,
//     required this.consumerSecret,
//   });

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     final credentials = '$consumerKey:$consumerSecret';
//     final base64Str = base64Encode(utf8.encode(credentials));
//     options.headers['Authorization'] = 'Basic $base64Str';
//     handler.next(options);
//   }

//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     if (err.response?.statusCode == 401) {
//       // Handle unauthorized error
//       handler.reject(err);
//     } else {
//       handler.next(err);
//     }
//   }
// }
