import '../../domain/entities/browsing_history_item.dart';

class BrowsingHistoryItemModel {
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
  final DateTime viewedAt;

  BrowsingHistoryItemModel({
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
    required this.viewedAt,
  });

  factory BrowsingHistoryItemModel.fromEntity(BrowsingHistoryItem item) {
    return BrowsingHistoryItemModel(
      id: item.id,
      name: item.name,
      slug: item.slug,
      permalink: item.permalink,
      description: item.description,
      shortDescription: item.shortDescription,
      price: item.price,
      regularPrice: item.regularPrice,
      salePrice: item.salePrice,
      imageUrls: item.imageUrls,
      categories: item.categories,
      attributes: item.attributes,
      stockStatus: item.stockStatus,
      priceHtml: item.priceHtml,
      viewedAt: item.viewedAt,
    );
  }

  BrowsingHistoryItem toEntity() {
    return BrowsingHistoryItem(
      id: id,
      name: name,
      slug: slug,
      permalink: permalink,
      description: description,
      shortDescription: shortDescription,
      price: price,
      regularPrice: regularPrice,
      salePrice: salePrice,
      imageUrls: imageUrls,
      categories: categories,
      attributes: attributes,
      stockStatus: stockStatus,
      priceHtml: priceHtml,
      viewedAt: viewedAt,
    );
  }

  factory BrowsingHistoryItemModel.fromJson(Map<String, dynamic> json) {
    return BrowsingHistoryItemModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      permalink: json['permalink'] as String? ?? '',
      description: json['description'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      price: json['price'] as String? ?? '',
      regularPrice: json['regularPrice'] as String? ?? '',
      salePrice: json['salePrice'] as String? ?? '',
      imageUrls:
          (json['imageUrls'] as List?)?.map((e) => e as String).toList() ??
              <String>[],
      categories:
          (json['categories'] as List?)?.map((e) => e as String).toList() ??
              <String>[],
      attributes:
          (json['attributes'] as List?)?.map((e) => e as String).toList() ??
              <String>[],
      stockStatus: json['stockStatus'] as String? ?? '',
      priceHtml: json['priceHtml'] as String? ?? '',
      viewedAt: json['viewedAt'] != null
          ? DateTime.parse(json['viewedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'permalink': permalink,
      'description': description,
      'shortDescription': shortDescription,
      'price': price,
      'regularPrice': regularPrice,
      'salePrice': salePrice,
      'imageUrls': imageUrls,
      'categories': categories,
      'attributes': attributes,
      'stockStatus': stockStatus,
      'priceHtml': priceHtml,
      'viewedAt': viewedAt.toIso8601String(),
    };
  }
}
