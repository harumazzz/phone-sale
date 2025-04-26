part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  const ProductLoaded({required this.products});

  final List<ProductResponse> products;

  @override
  List<Object> get props => [products];
}

final class ProductError extends ProductState {
  const ProductError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
