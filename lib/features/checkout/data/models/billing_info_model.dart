import 'package:hive/hive.dart';
import '../../domain/entities/billing_info.dart';

part 'billing_info_model.g.dart';

@HiveType(typeId: 3)
class BillingInfoModel extends HiveObject {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String phone;

  @HiveField(4)
  final String address;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final String state;

  @HiveField(7)
  final String zip;

  BillingInfoModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory BillingInfoModel.fromEntity(BillingInfo entity) {
    return BillingInfoModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      zip: entity.zip,
    );
  }

  BillingInfo toEntity() {
    return BillingInfo(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      address: address,
      city: city,
      state: state,
      zip: zip,
    );
  }
}
 