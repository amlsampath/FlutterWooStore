import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Category>>> getCategories() async {
    final result = await remoteDataSource.getCategories();
    return result.fold(
      (failure) => Left(failure),
      (categoryModels) =>
          Right(categoryModels.map((model) => model.toEntity()).toList()),
    );
  }
}
