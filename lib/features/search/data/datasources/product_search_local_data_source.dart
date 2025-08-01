import 'package:hive/hive.dart';
import '../models/product_search_model.dart';

abstract class ProductSearchLocalDataSource {
  Future<void> saveProducts(List<Map<String, dynamic>> products);
  Future<List<ProductSearchModel>> searchProducts(String query);
  Future<void> clearProducts();
}

class ProductSearchLocalDataSourceImpl implements ProductSearchLocalDataSource {
  final Box<ProductSearchModel> productBox;

  ProductSearchLocalDataSourceImpl(this.productBox);

  @override
  Future<void> saveProducts(List<Map<String, dynamic>> products) async {
    await productBox.clear(); // Clear existing products

    for (final product in products) {
      final model = ProductSearchModel.fromJson(product);
      await productBox.put(model.id.toString(), model);
    }
  }

  @override
  Future<List<ProductSearchModel>> searchProducts(String query) async {
    final normalizedQuery = query.toLowerCase().trim();
    if (normalizedQuery.isEmpty) return [];

    return productBox.values.where((product) {
      final name = product.name.toLowerCase();
      final description = product.description.toLowerCase();
      final category = product.category.toLowerCase();

      return name.contains(normalizedQuery) ||
          description.contains(normalizedQuery) ||
          category.contains(normalizedQuery);
    }).toList();
  }

  @override
  Future<void> clearProducts() async {
    await productBox.clear();
  }
}
