part of 'category_search_bloc.dart';

sealed class CategorySearchEvent extends Equatable {
  const CategorySearchEvent();
}

final class CategorySearchByIdEvent extends CategorySearchEvent {
  const CategorySearchByIdEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
