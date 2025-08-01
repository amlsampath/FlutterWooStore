import '../models/auth_token_model.dart';
import '../models/user_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response_handler.dart';
import '../../../../core/network/dio_client.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<Either<Failure, AuthTokenModel>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, AuthTokenModel>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, UserModel>> getCurrentUser({required String token});

  Future<Either<Failure, AuthTokenModel>> refreshToken();

  Future<Either<Failure, void>> resetPassword({
    required String email,
  });

  Future<Either<Failure, UserModel>> updateProfile(
    User user, {
    String? password,
    Map<String, dynamic>? billing,
    Map<String, dynamic>? shipping,
    String? avatarUrl,
  });

  Future<Either<Failure, UserModel>> getUserById(int customerId);

  Future<Either<Failure, void>> deleteAccount(int customerId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;
  final String baseUrl;

  AuthRemoteDataSourceImpl({
    required DioClient dioClient,
    required this.baseUrl,
  }) : _dioClient = dioClient;

  @override
  Future<Either<Failure, AuthTokenModel>> login({
    required String username,
    required String password,
  }) async {
    return ApiResponseHandler.handleResponse<AuthTokenModel>(
      request: () => _dioClient.dio.post(
        '$baseUrl/wp-json/jwt-auth/v1/token',
        data: {
          'username': username,
          'password': password,
        },
      ),
      onSuccess: (data) {
        print('AuthTokenModel: ${AuthTokenModel.fromWPJson(data)}');
        return AuthTokenModel.fromWPJson(data);
      },
    );
  }

  @override
  Future<Either<Failure, AuthTokenModel>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    // Validate email format
    if (!_isValidEmail(email)) {
      return const Left(ValidationFailure(
        message: 'Invalid email format',
        errors: {
          'email': ['Invalid email format']
        },
      ));
    }

    // Validate password strength
    if (!_isStrongPassword(password)) {
      return const Left(ValidationFailure(
        message:
            'Password must be at least 8 characters and include uppercase, lowercase, number and special character',
        errors: {
          'password': ['Password is not strong enough']
        },
      ));
    }

    // Validate username
    if (username.length < 3) {
      return const Left(ValidationFailure(
        message: 'Username must be at least 3 characters',
        errors: {
          'username': ['Username is too short']
        },
      ));
    }

    final registerResult =
        await ApiResponseHandler.handleResponse<Map<String, dynamic>>(
      request: () => _dioClient.dio.post(
        '$baseUrl/wp-json/wc/v3/customers',
        data: {
          'email': email,
          'first_name': firstName,
          'last_name': lastName,
          'username': username,
          'password': password,
        },
      ),
      onSuccess: (data) => data as Map<String, dynamic>,
    );

    return registerResult.fold(
      (failure) => Left(failure),
      (_) async {
        final loginResult = await login(
          username: username,
          password: password,
        );
        return loginResult;
      },
    );
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUser(
      {required String token}) async {
    final userResult =
        await ApiResponseHandler.handleResponse<Map<String, dynamic>>(
      request: () => _dioClient.dio.get(
        '$baseUrl/wp-json/wp/v2/users/me',
        // options: Options(
        //   headers: {
        //     'Authorization': 'Bearer $token',
        //   },
        // ),
      ),
      onSuccess: (data) => data as Map<String, dynamic>,
    );

    return userResult.fold(
      (failure) => Left(failure),
      (userData) async {
        // Then get the detailed customer data from WooCommerce
        return ApiResponseHandler.handleResponse<UserModel>(
          request: () => _dioClient.dio
              .get('$baseUrl/wp-json/wc/v3/customers/${userData['id']}'),
          onSuccess: (data) {
            // Transform WooCommerce customer data to UserModel
            return UserModel(
              id: data['id'] as int,
              email: data['email'] as String,
              username: data['username'] as String,
              firstName: data['first_name'] as String,
              lastName: data['last_name'] as String,
              avatarUrl: data['avatar_url'] as String?,
              billing: data['billing'] as Map<String, dynamic>?,
              shipping: data['shipping'] as Map<String, dynamic>?,
              roles: [data['role'] as String],
            );
          },
        );
      },
    );
  }

  @override
  Future<Either<Failure, AuthTokenModel>> refreshToken() async {
    return ApiResponseHandler.handleResponse<AuthTokenModel>(
      request: () => _dioClient.dio.post(
        '$baseUrl/wp-json/jwt-auth/v1/token/refresh',
      ),
      onSuccess: (data) => AuthTokenModel.fromWPJson(data),
    );
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
  }) async {
    // Validate email format first
    if (!_isValidEmail(email)) {
      return const Left(ValidationFailure(
        message: 'Invalid email format',
        errors: {
          'email': ['Invalid email format']
        },
      ));
    }

    try {
      return ApiResponseHandler.handleResponse<void>(
        request: () => _dioClient.dio.post(
          '$baseUrl/wp-json/wp/v2/users/lost-password',
          data: {
            'email': email,
          },
        ),
        onSuccess: (_) {},
      );
    } catch (e) {
      // Return a specific message for reset password failures
      // without exposing whether the email exists in the system (security best practice)
      return const Left(ServerFailure(
        message:
            'If your email is registered with us, you will receive password reset instructions shortly',
      ));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateProfile(
    User user, {
    String? password,
    Map<String, dynamic>? billing,
    Map<String, dynamic>? shipping,
    String? avatarUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'email': user.email,
        'first_name': user.firstName,
        'last_name': user.lastName,
      };
      if (password != null && password.isNotEmpty) {
        data['password'] = password;
      }
      if (billing != null) {
        data['billing'] = billing;
      }
      if (shipping != null) {
        data['shipping'] = shipping;
      }
      if (avatarUrl != null && avatarUrl.isNotEmpty) {
        data['avatar_url'] = avatarUrl;
      }
      final response = await _dioClient.dio.patch(
        '$baseUrl/wp-json/wc/v3/customers/${user.id}',
        data: data,
      );
      return Right(UserModel.fromJson(response.data));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to update profile: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getUserById(int customerId) async {
    return ApiResponseHandler.handleResponse<UserModel>(
      request: () =>
          _dioClient.dio.get('$baseUrl/wp-json/wc/v3/customers/$customerId'),
      onSuccess: (data) => UserModel.fromJson(data),
    );
  }

  @override
  Future<Either<Failure, void>> deleteAccount(int customerId) async {
    return ApiResponseHandler.handleResponse<void>(
      request: () => _dioClient.dio.delete(
        '$baseUrl/wp-json/wc/v3/customers/$customerId',
        queryParameters: {'force': true},
      ),
      onSuccess: (_) {},
    );
  }

  Map<String, List<String>> _parseValidationErrors(Map<String, dynamic> data) {
    final Map<String, List<String>> errors = {};

    if (data.containsKey('data') && data['data'] is Map) {
      final Map<String, dynamic> errorData =
          data['data'] as Map<String, dynamic>;

      errorData.forEach((key, value) {
        if (value is String) {
          errors[key] = [value];
        } else if (value is List) {
          errors[key] = value.map((e) => e.toString()).toList();
        }
      });
    }

    return errors;
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  // Password strength validation
  bool _isStrongPassword(String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character
    final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>])[A-Za-z\d!@#$%^&*(),.?":{}|<>]{8,}$');
    return passwordRegex.hasMatch(password);
  }
}
