import 'package:equatable/equatable.dart';

class ShippingInfo extends Equatable {
  final String firstName;
  final String lastName;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zip;

  const ShippingInfo({
    required this.firstName,
    required this.lastName,
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
        phone,
        address,
        city,
        state,
        zip,
      ];
}
