part of 'product_bloc.dart';

@immutable
sealed class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {
  const ProductInitial();
}

final class ProductLoading extends ProductState {
  const ProductLoading();
}

final class ProductLoaded extends ProductState {
  const ProductLoaded({required this.products});
  final List<ProductResponse> products;

  @override
  List<Object?> get props => [products];

  int get size => products.length;

  ProductResponse operator [](int index) {
    assert(index <= products.length);
    return products[index];
  }
}

final class ProductLoadError extends ProductState {
  const ProductLoadError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
