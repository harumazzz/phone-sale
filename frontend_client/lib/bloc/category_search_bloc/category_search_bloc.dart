import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/response/product_response.dart';
import '../../repository/product_repository.dart';

part 'category_search_event.dart';
part 'category_search_state.dart';

class CategorySearchBloc
    extends Bloc<CategorySearchEvent, CategorySearchState> {
  CategorySearchBloc({required this.productRepository})
    : super(const CategorySearchInitial()) {
    on<CategorySearchByIdEvent>(_onSearch);
  }

  final ProductRepository productRepository;

  Future<void> _onSearch(
    CategorySearchByIdEvent event,
    Emitter<CategorySearchState> emit,
  ) async {
    try {
      emit(const CategorySearchLoading());
      final results = await productRepository.getProductsByCategoryId(
        id: event.id,
      );
      emit(CategorySearchLoaded(products: results));
    } catch (e) {
      CategorySearchError(message: e.toString());
    }
  }
}
