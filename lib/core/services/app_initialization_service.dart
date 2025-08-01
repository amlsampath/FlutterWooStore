import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/search/data/datasources/product_search_local_data_source.dart';
import '../../features/search/data/models/product_search_model.dart';
import 'package:hive/hive.dart';

class AppInitializationService {
  final ProductRepository productRepository;
  final ProductSearchLocalDataSource localDataSource;
  final Box<ProductSearchModel> productSearchBox;

  AppInitializationService({
    required this.productRepository,
    required this.localDataSource,
    required this.productSearchBox,
  });

  Future<void> initialize() async {
    await _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    try {
      // Only initialize if the box is empty
      if (productSearchBox.isEmpty) {
        print('Initializing products in Hive...');

        final result = await productRepository.searchProducts(
          query: '',
          page: 1,
          perPage: 100, // Fetch first 100 products
        );

        result.fold(
          (failure) => print('Error initializing products: $failure'),
          (products) async {
            final productsJson = products
                .map((product) => {
                      'id': product.id,
                      'name': product.name,
                      'description': product.description,
                      'images': [
                        {
                          'src': product.imageUrls.isNotEmpty
                              ? product.imageUrls[0]
                              : ''
                        }
                      ],
                      'price': product.price,
                      'categories': [
                        {
                          'name': product.categories.isNotEmpty
                              ? product.categories[0]
                              : ''
                        }
                      ],
                    })
                .toList();

            await localDataSource.saveProducts(productsJson);
            print('Successfully initialized products in Hive');
          },
        );
      } else {
        print('Products already initialized in Hive');
      }
    } catch (e) {
      print('Error in _initializeProducts: $e');
    }
  }
}
