import 'package:dartz/dartz.dart';
import '../entities/product.dart';
import '../../../../core/error/failures.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int perPage = 10,
  });

  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    int page = 1,
    int perPage = 10,
  });

  Future<Either<Failure, Product>> getProductById(int id);

  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int perPage = 10,
  });
}
