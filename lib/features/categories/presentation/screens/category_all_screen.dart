import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_shimmer.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../domain/repositories/category_repository.dart';
import '../bloc/category_bloc.dart';
import 'package:go_router/go_router.dart';

class CategoryAllScreen extends StatelessWidget {
  const CategoryAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocProvider(
        create: (context) =>
            CategoryBloc(repository: GetIt.I<CategoryRepository>())
              ..add(LoadCategories()),
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryInitial || state is CategoryLoading) {
              return const Center(
                  child: AppLoadingShimmer(height: 120, borderRadius: 12));
            }
            if (state is CategoryError) {
              return AppErrorState(
                message: state.message,
                onRetry: () =>
                    context.read<CategoryBloc>().add(LoadCategories()),
              );
            }
            if (state is CategoriesLoaded) {
              if (state.categories.isEmpty) {
                return const AppEmptyState(
                  message: 'No categories found',
                  icon: Icons.category_outlined,
                );
              }
              return Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigate to category products screen
                        context.push(
                          '/category/${category.id}',
                          extra: {'name': category.name},
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (category.imageUrl != null &&
                                category.imageUrl!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  category.imageUrl!,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.image,
                                          color: Colors.grey[400]),
                                ),
                              )
                            else
                              Icon(Icons.category,
                                  size: 60, color: Colors.grey[400]),
                            const SizedBox(height: 12),
                            Text(
                              category.name,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
