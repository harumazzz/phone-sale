part of 'product_search_bloc.dart';

@immutable
sealed class ProductSearchState extends Equatable {
  const ProductSearchState();

  @override
  List<Object> get props => [];
}

class ProductSearchInitial extends ProductSearchState {
  const ProductSearchInitial();
}

class ProductSearchLoading extends ProductSearchState {
  const ProductSearchLoading();
}

class ProductSearchLoaded extends ProductSearchState {
  const ProductSearchLoaded({required this.products, required this.query});
  final List<ProductResponse> products;
  final String query;

  ProductResponse operator [](int index) {
    assert(index <= products.length);
    return products[index];
  }

  int get size => products.length;

  @override
  List<Object> get props => [products, query];
}

class ProductSearchError extends ProductSearchState {
  const ProductSearchError({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}
