import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/shipping_zone.dart';

abstract class ShippingRepository {
  Future<Either<Failure, List<ShippingZone>>> getShippingZones();
  Future<Either<Failure, List<ShippingMethod>>> getShippingMethodsForZone(
      int zoneId);
}
