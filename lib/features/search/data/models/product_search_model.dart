import 'package:hive/hive.dart';
import '../../../products/domain/entities/product.dart';

part 'product_search_model.g.dart';

@HiveType(typeId: 6)
class ProductSearchModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String imageUrl;

  @HiveField(4)
  final String price;

  @HiveField(5)
  final String category;

  ProductSearchModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
  });

  factory ProductSearchModel.fromJson(Map<String, dynamic> json) {
    return ProductSearchModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['images'][0]['src'] as String,
      price: json['price'] as String,
      category: json['categories'][0]['name'] as String,
    );
  }

  Product toProduct() {
    return Product(
      id: id,
      name: name,
      slug: '',
      permalink: '',
      description: description,
      shortDescription: '',
      price: price,
      regularPrice: '',
      salePrice: '',
      imageUrls: [imageUrl],
      categories: [category],
      attributes: const [],
      stockStatus: '',
      priceHtml: '',
    );
  }
}
