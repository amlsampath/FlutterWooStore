import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/app_category_item.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../features/categories/presentation/bloc/category_bloc.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const AppShimmerCategoryList();
        }

        if (state is CategoryError) {
          return AppErrorView(
            message: 'Error loading categories',
            onRetry: () {
              context.read<CategoryBloc>().add(LoadCategories());
            },
          );
        }

        if (state is CategoriesLoaded) {
          if (state.categories.isEmpty) {
            return const AppEmptyView(
              message: 'No categories available',
              icon: Icons.category_outlined,
            );
          }

          return SizedBox(
            height: 100,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return AppCategoryItem(
                  name: category.name,
                  imageUrl: category.imageUrl,
                  onTap: () {
                    context.push(
                      '/category/${category.id}',
                      extra: {'name': category.name},
                    );
                  },
                );
              },
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
