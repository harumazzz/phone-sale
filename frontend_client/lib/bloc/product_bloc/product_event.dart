part of 'product_bloc.dart';

@immutable
sealed class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

final class ProductFetch extends ProductEvent {
  const ProductFetch();
}

final class ProductSearchByCategory extends ProductEvent {
  const ProductSearchByCategory({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}
