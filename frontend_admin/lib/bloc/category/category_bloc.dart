import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/request/category_request.dart';
import '../../model/response/category_response.dart';
import '../../repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<LoadCategoryEvent>(_onLoadCategoryEvent);
    on<AddCategoryEvent>(_onAddCategoryEvent);
    on<EditCategoryEvent>(_onEditCategoryEvent);
    on<DeleteCategoryEvent>(_onDeleteCategoryEvent);
  }

  final CategoryRepository categoryRepository;

  Future<void> _onLoadCategoryEvent(
    LoadCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      final categories = await categoryRepository.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> _onAddCategoryEvent(
    AddCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await categoryRepository.addCategory(
        request: CategoryRequest(name: event.name),
      );
      final categories = await categoryRepository.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> _onEditCategoryEvent(
    EditCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await categoryRepository.editCategory(
        id: event.id,
        request: CategoryRequest(name: event.name),
      );
      final categories = await categoryRepository.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> _onDeleteCategoryEvent(
    DeleteCategoryEvent event,
    Emitter<CategoryState> emit,
  ) async {
    emit(CategoryLoading());
    try {
      await categoryRepository.deleteCategory(id: event.id);
      final categories = await categoryRepository.getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}
