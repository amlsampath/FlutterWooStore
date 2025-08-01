import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String permalink;
  final String description;
  final String shortDescription;
  final String price;
  final String regularPrice;
  final String salePrice;
  final List<String> imageUrls;
  final List<String> categories;
  final List<String> attributes;
  final String stockStatus;
  final String priceHtml;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.permalink,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.regularPrice,
    required this.salePrice,
    required this.imageUrls,
    required this.categories,
    required this.attributes,
    required this.stockStatus,
    required this.priceHtml,
  });

  @override
  List<Object> get props => [
        id,
        name,
        slug,
        permalink,
        description,
        shortDescription,
        price,
        regularPrice,
        salePrice,
        imageUrls,
        categories,
        attributes,
        stockStatus,
        priceHtml,
      ];
}
