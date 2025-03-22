import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/response/product_response.dart';
import '../../repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required this.productRepository})
    : super(const ProductInitial()) {
    on<ProductFetch>(_onFetch);
    on<ProductSearchByCategory>(_onDetchByCategoryId);
  }

  Future<void> _onFetch(ProductFetch event, Emitter<ProductState> emit) async {
    try {
      emit(const ProductLoading());
      final data = await productRepository.getProducts();
      emit(ProductLoaded(products: data));
    } catch (e) {
      emit(ProductLoadError(message: e.toString()));
    }
  }

  Future<void> _onDetchByCategoryId(
    ProductSearchByCategory event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(const ProductLoading());
      final data = await productRepository.getProductsByCategoryId(
        id: event.id,
      );
      emit(ProductLoaded(products: data));
    } catch (e) {
      emit(ProductLoadError(message: e.toString()));
    }
  }

  final ProductRepository productRepository;
}
