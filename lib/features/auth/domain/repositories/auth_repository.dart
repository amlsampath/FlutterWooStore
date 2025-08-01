import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_token.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
    String firstName = '',
    String lastName = '',
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, void>> logout();

  Future<AuthToken?> getStoredToken();

  Future<bool> isLoggedIn();

  Future<Either<Failure, void>> resetPassword({
    required String email,
  });

  Future<Either<Failure, User>> updateProfile(
    User user, {
    String? password,
    Map<String, dynamic>? billing,
    Map<String, dynamic>? shipping,
    String? avatarUrl,
  });

  Future<Either<Failure, User>> getUserById(int customerId);

  Future<Either<Failure, void>> deleteAccount(int customerId);
}
