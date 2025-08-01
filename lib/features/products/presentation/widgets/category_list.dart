import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_filter_chip.dart';
import '../../../../core/widgets/app_loading_shimmer.dart';
import '../../../../features/categories/presentation/bloc/category_bloc.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16 : 8,
                    right: index == 4 ? 16 : 8,
                  ),
                  child: const AppLoadingShimmer(
                    height: 32,
                    width: 80,
                    borderRadius: 20,
                  ),
                );
              },
            ),
          );
        }

        if (state is CategoriesLoaded) {
          final categories = state.categories;
          final selectedCategory = state.selectedCategory?.name;

          return Container(
            height: 50,
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1, // +1 for "All" category
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final category = isAll ? "All" : categories[index - 1].name;
                final isSelected = isAll
                    ? selectedCategory == null
                    : category == selectedCategory;

                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16 : 8,
                    right: index == categories.length ? 16 : 8,
                  ),
                  child: AppFilterChip(
                    label: category,
                    isSelected: isSelected,
                    onTap: () {
                      context.read<CategoryBloc>().add(
                            SelectCategory(
                                isAll ? null : categories[index - 1]),
                          );
                    },
                  ),
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
