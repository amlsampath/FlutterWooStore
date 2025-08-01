import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'slug')
  final String slug;

  @JsonKey(name: 'image')
  final CategoryImageModel? image;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  Category toEntity() {
    return Category(
      id: id,
      name: name,
      slug: slug,
      imageUrl: image?.src,
    );
  }
}

@JsonSerializable()
class CategoryImageModel {
  @JsonKey(name: 'src')
  final String src;

  CategoryImageModel({required this.src});

  factory CategoryImageModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryImageModelToJson(this);
}
