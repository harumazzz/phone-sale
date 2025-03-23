import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/response/product_response.dart';
import '../../repository/product_repository.dart';

part 'product_search_event.dart';
part 'product_search_state.dart';

class ProductSearchBloc extends Bloc<ProductSearchEvent, ProductSearchState> {
  ProductSearchBloc({required this.productRepository})
    : super(const ProductSearchInitial()) {
    on<ProductTypedEvent>(_onSearch);
  }

  Future<void> _onSearch(
    ProductTypedEvent event,
    Emitter<ProductSearchState> emit,
  ) async {
    try {
      emit(const ProductSearchLoading());
      final results = await productRepository.getProductsByName(
        name: event.query,
      );
      emit(ProductSearchLoaded(products: results));
    } catch (e) {
      ProductSearchError(message: e.toString());
    }
  }

  final ProductRepository productRepository;
}
