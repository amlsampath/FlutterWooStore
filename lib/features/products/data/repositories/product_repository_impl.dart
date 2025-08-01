import 'package:dartz/dartz.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';
import '../../../../core/error/failures.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int perPage = 10,
  }) async {
    final result = await remoteDataSource.getProducts(
      page: page,
      perPage: perPage,
    );
    return result.fold(
      (failure) => Left(failure),
      (productModels) =>
          Right(productModels.map((model) => _mapToEntity(model)).toList()),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts({
    required String query,
    int page = 1,
    int perPage = 10,
  }) async {
    final result = await remoteDataSource.searchProducts(
      query: query,
      page: page,
      perPage: perPage,
    );
    return result.fold(
      (failure) => Left(failure),
      (productModels) =>
          Right(productModels.map((model) => _mapToEntity(model)).toList()),
    );
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    final result = await remoteDataSource.getProductById(id);
    return result.fold(
      (failure) => Left(failure),
      (productModel) => Right(_mapToEntity(productModel)),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory({
    required String categoryId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final result = await remoteDataSource.getProductsByCategory(
        categoryId: categoryId,
        page: page,
        perPage: perPage,
      );
      return result.fold(
        (failure) => Left(failure),
        (productModels) =>
            Right(productModels.map((model) => _mapToEntity(model)).toList()),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  Product _mapToEntity(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      slug: model.slug,
      permalink: model.permalink,
      description: model.description,
      shortDescription: model.shortDescription,
      price: model.price,
      regularPrice: model.regularPrice,
      salePrice: model.salePrice,
      imageUrls: model.images.map((image) => image.src).toList(),
      categories: model.categories.map((category) => category.name).toList(),
      attributes: model.attributes
          .map((attribute) =>
              '${attribute.name}: ${attribute.options.join(", ")}')
          .toList(),
      stockStatus: model.stockStatus,
      priceHtml: model.priceHtml,
    );
  }
}
