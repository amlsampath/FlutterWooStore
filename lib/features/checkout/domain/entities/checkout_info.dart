import 'package:equatable/equatable.dart';
import '../../../cart/domain/entities/cart_item.dart';
import 'shipping_info.dart';

class CheckoutInfo {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double discount;
  final ShippingInfo? shippingInfo;
  final BillingInfo? billingInfo;
  final ShippingMethod? shippingMethod;

  const CheckoutInfo({
    required this.items,
    required this.subtotal,
    required this.tax,
    this.discount = 0,
    this.shippingInfo,
    this.billingInfo,
    this.shippingMethod,
  });

  double get total => subtotal + tax + (shippingMethod?.price ?? 0) - discount;
}

class ShippingMethod {
  final String id;
  final String name;
  final String description;
  final double price;

  const ShippingMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });

  static const List<ShippingMethod> shippingMethods = [
    ShippingMethod(
      id: 'standard',
      name: 'Standard Shipping',
      description: '3-5 business days',
      price: 5.99,
    ),
    ShippingMethod(
      id: 'express',
      name: 'Express Shipping',
      description: '1-2 business days',
      price: 12.99,
    ),
    ShippingMethod(
      id: 'overnight',
      name: 'Overnight Shipping',
      description: 'Next business day',
      price: 24.99,
    ),
  ];
}

class BillingInfo extends Equatable {
  final String fullName;
  final String phone;
  final String email;
  final String street;
  final String city;
  final String postcode;
  final String country;

  const BillingInfo({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.street,
    required this.city,
    required this.postcode,
    required this.country,
  });

  factory BillingInfo.empty() {
    return const BillingInfo(
      fullName: '',
      phone: '',
      email: '',
      street: '',
      city: '',
      postcode: '',
      country: '',
    );
  }

  BillingInfo copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? street,
    String? city,
    String? postcode,
    String? country,
  }) {
    return BillingInfo(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      street: street ?? this.street,
      city: city ?? this.city,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
    );
  }

  bool get isValid {
    return fullName.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty &&
        street.isNotEmpty &&
        city.isNotEmpty &&
        postcode.isNotEmpty &&
        country.isNotEmpty;
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'street': street,
      'city': city,
      'postcode': postcode,
      'country': country,
    };
  }

  @override
  List<Object?> get props => [
        fullName,
        phone,
        email,
        street,
        city,
        postcode,
        country,
      ];
}
