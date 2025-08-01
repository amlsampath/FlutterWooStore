import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    String message = 'Network connection error',
    String? code,
  }) : super(message: message, code: code);
}

class AuthenticationFailure extends Failure {
  const AuthenticationFailure({
    required String message,
    String? code,
  }) : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;

  const ValidationFailure({
    required String message,
    required this.errors,
    String? code,
  }) : super(message: message, code: code);

  @override
  List<Object?> get props => [...super.props, errors];
}

class CacheFailure extends Failure {
  const CacheFailure({
    String message = 'Cache operation failed',
    String? code,
  }) : super(message: message, code: code);
}

class ShippingFailure extends Failure {
  const ShippingFailure(String message) : super(message: message);
}
