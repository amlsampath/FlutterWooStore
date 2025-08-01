import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String slug;
  final String? imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, slug, imageUrl];
}
