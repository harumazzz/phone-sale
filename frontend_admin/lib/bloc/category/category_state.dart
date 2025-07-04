part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

final class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

final class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});

  @override
  List<Object> get props => [message];
}

final class CategoryLoaded extends CategoryState {
  final List<CategoryResponse> categories;

  const CategoryLoaded({required this.categories});

  @override
  List<Object> get props => [categories];

  CategoryResponse operator [](int index) => categories[index];

  int get length => categories.length;
}
