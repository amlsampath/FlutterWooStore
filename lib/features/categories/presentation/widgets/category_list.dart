import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/category_bloc.dart';
import '../../../../features/home/presentation/widgets/section_title.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryInitial) {
          context.read<CategoryBloc>().add(LoadCategories());
          return const SizedBox.shrink();
        }
        if (state is! CategoriesLoaded) {
          return const SizedBox.shrink();
        }
        final categories = state.categories;
        final selectedCategory = state.selectedCategory;
        return Container(
          padding: const EdgeInsets.only(top: 12, bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(
                title: 'Categories',
                actionText: 'See all',
                onActionPressed: () {
                  context.push('/categories/all');
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = category == selectedCategory;
                    return GestureDetector(
                      onTap: () {
                        context
                            .read<CategoryBloc>()
                            .add(SelectCategory(category));
                        context.push(
                          '/category/${category.id}',
                          extra: {'name': category.name},
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: category.imageUrl != null &&
                                    category.imageUrl!.isNotEmpty
                                ? Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        category.imageUrl!,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Icon(Icons.image,
                                                    color: Colors.grey[400]),
                                      ),
                                    ),
                                  )
                                : Icon(Icons.category, color: Colors.grey[400]),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            child: Text(
                              category.name,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
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
  }
}
