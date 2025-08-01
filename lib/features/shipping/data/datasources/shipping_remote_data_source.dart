import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/entities/shipping_zone.dart';

abstract class ShippingRemoteDataSource {
  Future<Either<Failure, List<ShippingZone>>> getShippingZones();
  Future<Either<Failure, List<ShippingMethod>>> getShippingMethodsForZone(
      int zoneId);
}

class ShippingRemoteDataSourceImpl implements ShippingRemoteDataSource {
  final DioClient _dioClient;

  ShippingRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Either<Failure, List<ShippingZone>>> getShippingZones() async {
    return ApiResponseHandler.handleResponse<List<ShippingZone>>(
      request: () => _dioClient.dio.get('/wp-json/wc/v3/shipping/zones'),
      onSuccess: (data) {
        if (data == null) {
          return const [];
        }

        try {
          final List<dynamic> zonesData = data as List<dynamic>;
          final zones = zonesData
              .map(
                  (json) => ShippingZone.fromJson(json as Map<String, dynamic>))
              .toList();
          print(
              'Successfully parsed ${zones.length} shipping zones'); // Debug log
          return zones;
        } catch (e) {
          print('Error parsing shipping zones: $e'); // Debug log
          throw Exception('Failed to parse shipping zones: $e');
        }
      },
      isShippingRequest: true,
    );
  }

  @override
  Future<Either<Failure, List<ShippingMethod>>> getShippingMethodsForZone(
      int zoneId) async {
    return ApiResponseHandler.handleResponse<List<ShippingMethod>>(
      request: () =>
          _dioClient.dio.get('/wp-json/wc/v3/shipping/zones/$zoneId/methods'),
      onSuccess: (data) {
        if (data == null) {
          return const [];
        }

        try {
          final List<dynamic> methodsData = data as List<dynamic>;
          final methods = methodsData
              .map((json) =>
                  ShippingMethod.fromJson(json as Map<String, dynamic>))
              .toList();
          print(
              'Successfully parsed ${methods.length} shipping methods for zone $zoneId'); // Debug log
          return methods;
        } catch (e) {
          print(
              'Error parsing shipping methods for zone $zoneId: $e'); // Debug log
          throw Exception('Failed to parse shipping methods: $e');
        }
      },
      isShippingRequest: true,
    );
  }
}
