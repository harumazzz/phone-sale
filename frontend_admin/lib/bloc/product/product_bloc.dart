import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/request/product_request.dart';
import '../../model/response/product_response.dart';
import '../../repository/product_repository.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<LoadProductEvent>(_onLoadProductEvent);
    on<AddProductEvent>(_onAddProductEvent);
    on<EditProductEvent>(_onEditProductEvent);
    on<DeleteProductEvent>(_onDeleteProductEvent);
  }

  final ProductRepository productRepository;

  Future<void> _onLoadProductEvent(LoadProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final products = await productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onAddProductEvent(AddProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productRepository.addProduct(request: event.request);
      final products = await productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onEditProductEvent(EditProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productRepository.editProduct(id: event.id, request: event.request);
      final products = await productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> _onDeleteProductEvent(DeleteProductEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      await productRepository.deleteProduct(id: event.id);
      final products = await productRepository.getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }
}
