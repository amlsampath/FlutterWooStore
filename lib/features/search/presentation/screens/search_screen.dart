import 'package:ecommerce_app/core/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/search_bloc.dart';
import '../../../../service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../data/datasources/product_search_local_data_source.dart';
import '../../data/models/product_search_model.dart';

class SearchScreen extends StatelessWidget {
  final Map<String, dynamic>? extraParams;

  const SearchScreen({super.key, this.extraParams});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => sl<SearchBloc>(),
      child: SearchScreenContent(extraParams: extraParams),
    );
  }
}

class SearchScreenContent extends StatefulWidget {
  final Map<String, dynamic>? extraParams;

  const SearchScreenContent({super.key, this.extraParams});

  @override
  State<SearchScreenContent> createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<SearchScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _shouldActivateVoiceSearch = false;
  List<ProductSearchModel> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeProducts();

    if (widget.extraParams != null) {
      if (widget.extraParams!.containsKey('initialQuery')) {
        final initialQuery = widget.extraParams!['initialQuery'] as String;
        _searchController.text = initialQuery;

        Future.microtask(() {
          if (initialQuery.isNotEmpty) {
            _performLocalSearch(initialQuery);
          }
        });
      }

      if (widget.extraParams!.containsKey('useVoiceInput')) {
        _shouldActivateVoiceSearch =
            widget.extraParams!['useVoiceInput'] as bool;
        if (_shouldActivateVoiceSearch) {
          Future.microtask(() {
            _startVoiceSearch();
          });
        }
      }
    }
  }

  Future<void> _initializeProducts() async {
    final searchBloc = context.read<SearchBloc>();
    searchBloc.add(const SearchProducts(query: '', loadMore: false));
  }

  void _performLocalSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    try {
      final localDataSource = sl<ProductSearchLocalDataSource>();
      final results = await localDataSource.searchProducts(query);

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      print('Error performing local search: $e');
      setState(() {
        _isSearching = false;
      });
      // You might want to show an error message to the user
    }
  }

  void _startVoiceSearch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Voice Search',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mic,
              size: AppDimensions.iconSizeXXL,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Listening...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _searchController.text = 'laptop';
                _performLocalSearch('laptop');
              },
              child: const Text('Simulate "laptop" search'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      // Load more results if needed
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          // Yellow header
          Container(
            width: double.infinity,
            height: 200,
            padding:
                const EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 32),
            color: AppColors.primary, // Material yellow 300
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Search Products',
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          // Floating search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Material(
                    elevation: 0,
                    color: Colors.transparent,
                    child: TextFormField(
                      controller: _searchController,
                      onChanged: (query) => _performLocalSearch(query),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search,
                            color: Colors.grey[500], size: 22),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear,
                                    color: Colors.grey[500], size: 22),
                                onPressed: () {
                                  _searchController.clear();
                                  _performLocalSearch('');
                                },
                              )
                            : null,
                        hintText: 'Search products...',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 0),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                      cursorColor: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: _isSearching
                ? const AppLoadingIndicator()
                : _searchResults.isEmpty
                    ? AppEmptyState(
                        message: _searchController.text.isEmpty
                            ? 'Search for products'
                            : 'No products found',
                        icon: _searchController.text.isEmpty
                            ? Icons.search
                            : Icons.search_off,
                        iconSize: AppDimensions.iconSizeXXL,
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(
                            top: 8, left: 12, right: 12, bottom: 8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final product = _searchResults[index];
                          return ProductCard(
                            product: product.toProduct(),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
