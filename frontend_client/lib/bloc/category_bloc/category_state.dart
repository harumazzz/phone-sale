part of 'category_bloc.dart';

@immutable
sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

final class CategoryInitial extends CategoryState {
  const CategoryInitial();
}

final class CategoryLoading extends CategoryState {
  const CategoryLoading();
}

final class CategoryLoaded extends CategoryState {
  const CategoryLoaded({required this.data});

  final List<CategoryResponse> data;

  int get size => data.length;

  CategoryResponse operator [](int index) {
    assert(index < data.length, '$index outside bounds');
    return data[index];
  }

  @override
  List<Object?> get props => [data];
}

final class CategoryError extends CategoryState {
  const CategoryError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
