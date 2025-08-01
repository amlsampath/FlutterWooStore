import 'package:flutter/material.dart';
import '../../../products/domain/entities/product.dart';
import '../../../../core/widgets/product_card.dart';
import '../../domain/entities/browsing_history_item.dart';

class BrowsingHistoryList extends StatelessWidget {
  final List<BrowsingHistoryItem> items;
  final void Function(BrowsingHistoryItem) onTap;

  const BrowsingHistoryList({
    Key? key,
    required this.items,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Text(
            'No browsing history yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontSize: 16,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final showSeeAll = items.length > 4;
    final visibleItems = showSeeAll ? items.take(4).toList() : items;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Browsing History',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (showSeeAll)
                  TextButton(
                    onPressed: () => _showAllBrowsingHistory(context, items),
                    child: const Text('See all'),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: visibleItems.length,
              padding: const EdgeInsets.all(0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = visibleItems[index];
                final product = Product(
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
                );
                return GestureDetector(
                  onTap: () => onTap(item),
                  child: ProductCard(
                    product: product,
                    showFavoriteButton: false,
                  ),
                );
              },
              shrinkWrap: true,
            ),
          ),
        ],
      ),
    );
  }

  void _showAllBrowsingHistory(
      BuildContext context, List<BrowsingHistoryItem> allItems) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Browsing History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      itemCount: allItems.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final item = allItems[index];
                        final product = Product(
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
                        );
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            onTap(item);
                          },
                          child: ProductCard(
                            product: product,
                            showFavoriteButton: false,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
