part of 'product_search_bloc.dart';

@immutable
sealed class ProductSearchEvent extends Equatable {
  const ProductSearchEvent();

  @override
  List<Object> get props => [];
}

final class ProductTypedEvent extends ProductSearchEvent {
  const ProductTypedEvent({required this.query});
  final String query;

  @override
  List<Object> get props => [query];
}
