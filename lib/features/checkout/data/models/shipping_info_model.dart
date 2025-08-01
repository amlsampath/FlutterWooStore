import 'package:hive/hive.dart';
import '../../domain/entities/shipping_info.dart';

part 'shipping_info_model.g.dart';

@HiveType(typeId: 4)
class ShippingInfoModel extends HiveObject {
  @HiveField(0)
  final String firstName;

  @HiveField(1)
  final String lastName;

  @HiveField(2)
  final String phone;

  @HiveField(3)
  final String address;

  @HiveField(4)
  final String city;

  @HiveField(5)
  final String state;

  @HiveField(6)
  final String zip;

  ShippingInfoModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zip,
  });

  factory ShippingInfoModel.fromEntity(ShippingInfo entity) {
    return ShippingInfoModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      address: entity.address,
      city: entity.city,
      state: entity.state,
      zip: entity.zip,
    );
  }

  ShippingInfo toEntity() {
    return ShippingInfo(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      address: address,
      city: city,
      state: state,
      zip: zip,
    );
  }
}
