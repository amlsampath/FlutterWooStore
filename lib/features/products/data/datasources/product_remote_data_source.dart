import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<Either<Failure, List<ProductModel>>> getProducts({
    int page = 1,
    int perPage = 10,
  });

  Future<Either<Failure, List<ProductModel>>> searchProducts({
    required String query,
    int page = 1,
    int perPage = 10,
  });

  Future<Either<Failure, ProductModel>> getProductById(int id);

  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int perPage = 10,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient _dioClient;

  ProductRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts({
    int page = 1,
    int perPage = 10,
  }) async {
    return ApiResponseHandler.handleResponse<List<ProductModel>>(
      request: () => _dioClient.dio.get(
        '/wp-json/wc/v3/products',
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      ),
      onSuccess: (data) {
        print(data);
        return (data as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      },
    );
  }

  @override
  Future<Either<Failure, List<ProductModel>>> searchProducts({
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    return ApiResponseHandler.handleResponse<List<ProductModel>>(
      request: () => _dioClient.dio.get(
        '/wp-json/wc/v3/products',
        queryParameters: {
          'search': query,
          'page': page,
          'per_page': perPage,
        },
      ),
      onSuccess: (data) {
        return (data as List)
            .map((json) => ProductModel.fromJson(json))
            .toList();
      },
    );
  }

  @override
  Future<Either<Failure, ProductModel>> getProductById(int id) async {
    return ApiResponseHandler.handleResponse<ProductModel>(
      request: () => _dioClient.dio.get(
        '/wp-json/wc/v3/products/$id',
      ),
      onSuccess: (data) {
        return ProductModel.fromJson(data);
      },
    );
  }

  @override
  Future<Either<Failure, List<ProductModel>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int perPage = 10,
  }) async {
    print(
        'Fetching products for category ID: $categoryId, page: $page, perPage: $perPage');
    return ApiResponseHandler.handleResponse<List<ProductModel>>(
      request: () => _dioClient.dio.get(
        '/wp-json/wc/v3/products',
        queryParameters: {
          'category': categoryId,
          'page': page,
          'per_page': perPage,
        },
      ),
      onSuccess: (data) {
        print('API response for category $categoryId: $data');
        if (data == null) {
          print('API returned null data for category $categoryId');
          return [];
        }
        try {
          final products = (data as List)
              .map((json) => ProductModel.fromJson(json))
              .toList();
          print(
              'Successfully parsed ${products.length} products for category $categoryId');
          return products;
        } catch (e) {
          print('Error parsing products for category $categoryId: $e');
          throw Exception('Failed to parse products: $e');
        }
      },
    );
  }
}
