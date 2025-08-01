import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'slug')
  final String slug;
  @JsonKey(name: 'permalink')
  final String permalink;
  @JsonKey(name: 'description')
  final String description;
  @JsonKey(name: 'short_description')
  final String shortDescription;
  @JsonKey(name: 'price')
  final String price;
  @JsonKey(name: 'regular_price')
  final String regularPrice;
  @JsonKey(name: 'sale_price')
  final String salePrice;
  @JsonKey(name: 'images')
  final List<ImageModel> images;
  @JsonKey(name: 'categories')
  final List<CategoryModel> categories;
  @JsonKey(name: 'attributes')
  final List<AttributeModel> attributes;
  @JsonKey(name: 'tags')
  final List<dynamic> tags;
  @JsonKey(name: 'default_attributes')
  final List<dynamic> defaultAttributes;
  @JsonKey(name: 'variations')
  final List<dynamic> variations;
  @JsonKey(name: 'grouped_products')
  final List<dynamic> groupedProducts;
  @JsonKey(name: 'menu_order')
  final int menuOrder;
  @JsonKey(name: 'price_html')
  final String priceHtml;
  @JsonKey(name: 'related_ids')
  final List<int> relatedIds;
  @JsonKey(name: 'meta_data')
  final List<dynamic> metaData;
  @JsonKey(name: 'stock_status')
  final String stockStatus;
  @JsonKey(name: 'has_options')
  final bool hasOptions;
  @JsonKey(name: 'post_password')
  final String postPassword;
  @JsonKey(name: 'global_unique_id')
  final String globalUniqueId;
  @JsonKey(name: 'brands')
  final List<dynamic> brands;
  @JsonKey(name: '_links')
  final Map<String, dynamic> links;

  ProductModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.images,
    required this.categories,
    required this.attributes,
    required this.tags,
    required this.defaultAttributes,
    required this.variations,
    required this.groupedProducts,
    required this.menuOrder,
    required this.priceHtml,
    required this.relatedIds,
    required this.metaData,
    required this.stockStatus,
    required this.hasOptions,
    required this.postPassword,
    required this.globalUniqueId,
    required this.brands,
    required this.links,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      slug: slug,
      permalink: permalink,
      description: description,
      shortDescription: shortDescription,
      price: price,
      regularPrice: regularPrice,
      salePrice: salePrice,
      imageUrls: images.map((image) => image.src).toList(),
      categories: categories.map((category) => category.name).toList(),
      attributes: attributes
          .map((attribute) =>
              '${attribute.name}: ${attribute.options.join(", ")}')
          .toList(),
      stockStatus: stockStatus,
      priceHtml: priceHtml,
    );
  }
}

@JsonSerializable()
class ImageModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'src')
  final String src;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'alt')
  final String alt;

  ImageModel({
    required this.id,
    required this.src,
    required this.name,
    required this.alt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) =>
      _$ImageModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageModelToJson(this);
}

@JsonSerializable()
class CategoryModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'slug')
  final String slug;

  CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class AttributeModel {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'slug')
  final String slug;
  @JsonKey(name: 'options')
  final List<String> options;

  AttributeModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.options,
  });

  factory AttributeModel.fromJson(Map<String, dynamic> json) =>
      _$AttributeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeModelToJson(this);
}
