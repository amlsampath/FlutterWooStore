import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../error/failures.dart';

class NoInternetConnectionFailure extends Failure {
  const NoInternetConnectionFailure({String message = 'No internet connection'})
      : super(message: message);
}

class ApiResponseHandler {
  static Future<Either<Failure, T>> handleResponse<T>({
    required Future<Response> Function() request,
    required T Function(dynamic data) onSuccess,
    bool isShippingRequest = false,
  }) async {
    try {
      // Check for internet connection before making the request
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('No internet connection');
        return const Left(NoInternetConnectionFailure());
      }
      print('Starting API request...');
      final response = await request();
      print('API response received: ${response.statusCode}');

      // Handle successful response
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        try {
          return Right(onSuccess(response.data));
        } catch (e) {
          print('Error parsing response data: $e'); // Debug log
          return Left(
              ServerFailure(message: 'Failed to parse response data: $e'));
        }
      }

      // Handle error response
      String errorMessage = 'Server error: ${response.statusCode}';
      if (response.data != null) {
        if (response.data is Map) {
          final data = response.data as Map;
          // Handle JWT authentication errors
          if (data.containsKey('code') &&
              data['code'].toString().startsWith('[jwt_auth]')) {
            if (data['code'] == '[jwt_auth] ip_blocked') {
              errorMessage =
                  data['message']?.toString().replaceAll('<br />', '') ??
                      'IP blocked due to too many login attempts';
            } else {
              errorMessage =
                  data['message']?.toString().replaceAll('<br />', '') ??
                      'Authentication error';
            }
          } else if (data.containsKey('message')) {
            errorMessage = data['message'].toString();
          } else if (data.containsKey('error')) {
            errorMessage = data['error'].toString();
          }
        } else if (response.data is String) {
          errorMessage = response.data.toString();
        }
      }

      print('Server returned error: $errorMessage'); // Debug log
      return Left(ServerFailure(message: errorMessage));
    } on DioException catch (e) {
      print('DioException: ${e.message}'); // Debug log
      String errorMessage = e.message ?? 'Network error occurred';

      if (e.response?.data != null) {
        if (e.response?.data is Map) {
          final data = e.response?.data as Map;
          // Handle JWT authentication errors
          if (data.containsKey('code') &&
              data['code'].toString().startsWith('[jwt_auth]')) {
            if (data['code'] == '[jwt_auth] ip_blocked') {
              errorMessage =
                  data['message']?.toString().replaceAll('<br />', '') ??
                      'IP blocked due to too many login attempts';
            } else {
              errorMessage =
                  data['message']?.toString().replaceAll('<br />', '') ??
                      'Authentication error';
            }
          } else if (data.containsKey('message')) {
            errorMessage = data['message'].toString();
          } else if (data.containsKey('error')) {
            errorMessage = data['error'].toString();
          }
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data.toString() ?? 'Unknown error';
        }
      }

      return Left(ServerFailure(message: errorMessage));
    } catch (e) {
      print('Unexpected error: $e'); // Debug log
      return Left(ServerFailure(message: 'Unexpected error: $e'));
    }
  }
}
