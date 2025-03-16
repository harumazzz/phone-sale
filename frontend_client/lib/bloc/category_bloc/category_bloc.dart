import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/response/category_response.dart';
import '../../repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required this.categoryRepository})
    : super(const CategoryInitial()) {
    on<LoadCategoryEvent>(_loadCategory);
  }
  final CategoryRepository categoryRepository;

  Future<void> _loadCategory(
    LoadCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(const CategoryLoading());
    try {
      final data = await categoryRepository.getCategories();
      emit(CategoryLoaded(data: data));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
