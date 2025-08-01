import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/shipping_zone.dart';
import '../../domain/repositories/shipping_repository.dart';
import '../datasources/shipping_remote_data_source.dart';

class ShippingRepositoryImpl implements ShippingRepository {
  final ShippingRemoteDataSource remoteDataSource;

  ShippingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ShippingZone>>> getShippingZones() async {
    try {
      print('Fetching shipping zones...'); // Debug log
      final zonesResult = await remoteDataSource.getShippingZones();

      return zonesResult.fold(
        (failure) {
          print('Failed to fetch shipping zones: $failure'); // Debug log
          return Left(failure);
        },
        (zones) async {
          final List<ShippingZone> updatedZones = [];
          print(
              'Successfully fetched ${zones.length} zones, fetching methods...'); // Debug log

          // For each zone, fetch its methods
          for (final zone in zones) {
            try {
              final methodsResult = await getShippingMethodsForZone(zone.id);

              methodsResult.fold(
                (failure) {
                  print(
                      'Failed to load methods for zone ${zone.id}: $failure'); // Debug log
                  // Add zone without methods on failure
                  updatedZones.add(zone);
                },
                (methods) {
                  print(
                      'Successfully loaded ${methods.length} methods for zone ${zone.id}'); // Debug log
                  // Add zone with methods on success
                  updatedZones.add(ShippingZone(
                    id: zone.id,
                    name: zone.name,
                    order: zone.order,
                    locations: zone.locations,
                    methods: methods,
                  ));
                },
              );
            } catch (e) {
              print(
                  'Error fetching methods for zone ${zone.id}: $e'); // Debug log
              // Add zone without methods on error
              updatedZones.add(zone);
            }
          }

          print('Completed fetching all shipping data'); // Debug log
          return Right(updatedZones);
        },
      );
    } catch (e) {
      print('Error in getShippingZones: $e'); // Debug log
      return Left(ShippingFailure('Failed to load shipping zones: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ShippingMethod>>> getShippingMethodsForZone(
      int zoneId) async {
    try {
      print('Fetching shipping methods for zone $zoneId...'); // Debug log
      final result = await remoteDataSource.getShippingMethodsForZone(zoneId);

      return result.fold(
        (failure) {
          print(
              'Failed to fetch shipping methods for zone $zoneId: $failure'); // Debug log
          return Left(failure);
        },
        (methods) {
          print(
              'Successfully fetched ${methods.length} methods for zone $zoneId'); // Debug log
          return Right(methods);
        },
      );
    } catch (e) {
      print('Error in getShippingMethodsForZone: $e'); // Debug log
      return Left(ShippingFailure(
          'Failed to load shipping methods for zone $zoneId: $e'));
    }
  }
}
