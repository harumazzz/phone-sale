part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoryEvent extends CategoryEvent {
  const LoadCategoryEvent();
}

class AddCategoryEvent extends CategoryEvent {
  final String name;

  const AddCategoryEvent({required this.name});

  @override
  List<Object> get props => [name];
}

class EditCategoryEvent extends CategoryEvent {
  final int id;

  final String name;

  const EditCategoryEvent({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

class DeleteCategoryEvent extends CategoryEvent {
  final int id;

  const DeleteCategoryEvent({required this.id});

  @override
  List<Object> get props => [id];
}
