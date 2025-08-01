part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class Login extends AuthEvent {
  final String username;
  final String password;

  const Login({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class Register extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const Register({
    required this.username,
    required this.email,
    required this.password,
    this.firstName = '',
    this.lastName = '',
  });

  @override
  List<Object?> get props => [username, email, password, firstName, lastName];
}

class ResetPassword extends AuthEvent {
  final String email;

  const ResetPassword({required this.email});

  @override
  List<Object?> get props => [email];
}

class CheckAuthStatus extends AuthEvent {}

class Logout extends AuthEvent {}

class SetGuestUser extends AuthEvent {}

class DeleteAccount extends AuthEvent {
  final int customerId;

  const DeleteAccount(this.customerId);

  @override
  List<Object?> get props => [customerId];
}
