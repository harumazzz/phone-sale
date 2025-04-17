part of 'category_search_bloc.dart';

sealed class CategorySearchState extends Equatable {
  const CategorySearchState();

  @override
  List<Object> get props => [];
}

final class CategorySearchInitial extends CategorySearchState {
  const CategorySearchInitial();
}

final class CategorySearchLoading extends CategorySearchState {
  const CategorySearchLoading();
}

final class CategorySearchLoaded extends CategorySearchState {
  const CategorySearchLoaded({required this.products});

  final List<ProductResponse> products;

  @override
  List<Object> get props => [products];

  int get size => products.length;

  ProductResponse operator [](int index) {
    assert(index <= products.length);
    return products[index];
  }
}

final class CategorySearchError extends CategorySearchState {
  const CategorySearchError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
