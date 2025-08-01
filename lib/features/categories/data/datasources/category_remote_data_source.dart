import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_response_handler.dart';
import '../../../../core/network/dio_client.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final DioClient _dioClient;

  CategoryRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    return ApiResponseHandler.handleResponse<List<CategoryModel>>(
      request: () => _dioClient.dio.get(
        '/wp-json/wc/v3/products/categories',
        queryParameters: {
          'per_page': 100, // Get maximum categories
          'orderby': 'name',
          'order': 'asc',
        },
      ),
      onSuccess: (data) {
        return (data as List)
            .map((json) => CategoryModel.fromJson(json))
            .toList();
      },
    );
  }
} 