import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_token.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  }) async {
    try {
      final tokenResult = await remoteDataSource.login(
        username: username,
        password: password,
      );

      return tokenResult.fold(
        (failure) => Left(failure),
        (token) async {
          await localDataSource.saveToken(token);
          final userResult =
              await remoteDataSource.getCurrentUser(token: token.token);
          return userResult.fold(
            (failure) => Left(failure),
            (user) async {
              await localDataSource.saveUser(user);
              return Right(user as User);
            },
          );
        },
      );
    } catch (e) {
      return Left(AuthenticationFailure(message: 'Failed to login: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
    String firstName = '',
    String lastName = '',
  }) async {
    try {
      final registerResult = await remoteDataSource.register(
        username: username,
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      return registerResult.fold(
        (failure) => Left(failure),
        (token) async {
          await localDataSource.saveToken(token);
          final userResult =
              await remoteDataSource.getCurrentUser(token: token.token);
          return userResult.fold(
            (failure) => Left(failure),
            (user) async {
              await localDataSource.saveUser(user);
              return Right(user as User);
            },
          );
        },
      );
    } catch (e) {
      return Left(AuthenticationFailure(message: 'Failed to register: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // First try to get from local storage
      final cachedUser = await localDataSource.getUser();
      if (cachedUser != null) {
        return Right(cachedUser as User);
      }

      // If not in cache, get from remote
      final token = await localDataSource.getToken();
      if (token == null || !token.isValid) {
        return const Left(AuthenticationFailure(message: 'Not authenticated'));
      }

      final userResult =
          await remoteDataSource.getCurrentUser(token: token.token);
      return userResult.fold(
        (failure) => Left(failure),
        (user) async {
          await localDataSource.saveUser(user);
          return Right(user as User);
        },
      );
    } catch (e) {
      return Left(
          AuthenticationFailure(message: 'Failed to get current user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.deleteToken();
      await localDataSource.deleteUser(); // Clear user data on logout
      return const Right(null);
    } catch (e) {
      return Left(AuthenticationFailure(message: 'Failed to logout: $e'));
    }
  }

  @override
  Future<AuthToken?> getStoredToken() async {
    return localDataSource.getToken();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null && token.isValid;
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String email,
  }) async {
    try {
      return remoteDataSource.resetPassword(email: email);
    } catch (e) {
      return Left(
          AuthenticationFailure(message: 'Failed to reset password: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile(
    User user, {
    String? password,
    Map<String, dynamic>? billing,
    Map<String, dynamic>? shipping,
    String? avatarUrl,
  }) async {
    final result = await remoteDataSource.updateProfile(
      user,
      password: password,
      billing: billing,
      shipping: shipping,
      avatarUrl: avatarUrl,
    );
    return result.fold(
      (failure) => Left(failure),
      (user) => Right(user as User),
    );
  }

  @override
  Future<Either<Failure, User>> getUserById(int customerId) async {
    try {
      final userResult = await remoteDataSource.getUserById(customerId);
      return userResult.fold(
        (failure) => Left(failure),
        (user) => Right(user as User),
      );
    } catch (e) {
      return Left(AuthenticationFailure(message: 'Failed to get user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(int customerId) async {
    try {
      final result = await remoteDataSource.deleteAccount(customerId);
      return result.fold(
        (failure) => Left(failure),
        (_) async {
          // Clear all local user data
          await localDataSource.deleteToken();
          await localDataSource.deleteUser();
          return const Right(null);
        },
      );
    } catch (e) {
      return Left(
          AuthenticationFailure(message: 'Failed to delete account: $e'));
    }
  }
}
