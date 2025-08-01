import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String? avatarUrl;
  final List<String> roles;
  final Map<String, dynamic>? billing;
  final Map<String, dynamic>? shipping;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.avatarUrl,
    required this.roles,
    this.billing,
    this.shipping,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        firstName,
        lastName,
        avatarUrl,
        roles,
        billing,
        shipping,
      ];

  bool get isAdmin => roles.contains('administrator');

  String get fullName => '$firstName $lastName'.trim();
}
