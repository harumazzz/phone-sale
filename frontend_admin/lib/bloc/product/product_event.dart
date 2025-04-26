part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductEvent extends ProductEvent {
  const LoadProductEvent();
}

class AddProductEvent extends ProductEvent {
  const AddProductEvent({required this.request});

  final ProductRequest request;

  @override
  List<Object?> get props => [request];
}

class EditProductEvent extends ProductEvent {
  const EditProductEvent({required this.id, required this.request});

  final int id;
  final ProductRequest request;

  @override
  List<Object?> get props => [id, request];
}

class DeleteProductEvent extends ProductEvent {
  const DeleteProductEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
