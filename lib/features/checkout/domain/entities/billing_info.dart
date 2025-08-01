import 'package:equatable/equatable.dart';

class BillingInfo extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zip;

  const BillingInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
  });

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        email,
        phone,
        address,
        city,
        state,
        zip,
      ];
}
