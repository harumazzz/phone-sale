import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/cart_item_data.dart';
import '../../model/request/cart_request.dart';
import '../../model/response/product_response.dart';
import '../../repository/cart_repository.dart';
import '../../repository/product_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.cartRepository, required this.productRepository}) : super(const CartInitial()) {
    on<CartLoadEvent>(_onLoad);
    on<CartAddEvent>(_onAdd);
    on<CartEditEvent>(_onEdit);
    on<CartDeleteEvent>(_onDelete);
    on<CartClearEvent>(_onClear);
    on<CartClearLocalEvent>(_onClearLocal);
  }

  final CartRepository cartRepository;

  final ProductRepository productRepository;

  Future<void> _onLoad(CartLoadEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final result = await cartRepository.getAllCart(customerId: event.customerId);
      final products = <ProductResponse>[];
      for (final cart in result) {
        final product = await productRepository.getProduct(id: cart.productId);
        products.add(product);
      }
      final carts = <CartItemData>[];
      for (var i = 0; i < result.length; i++) {
        carts.add(CartItemData(product: products[i], cartInfo: result[i]));
      }
      emit(CartLoaded(carts: carts));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAdd(CartAddEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      await cartRepository.addCart(
        request: CartRequest(customerId: event.customerId, productId: event.productId, quantity: event.quantity),
      );
      emit(const CartAdded());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onEdit(CartEditEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      await cartRepository.editCart(
        cartId: event.cartId,
        request: CartRequest(customerId: event.customerId, productId: event.productId, quantity: event.quantity),
      );
      emit(const CartEdited());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onDelete(CartDeleteEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      await cartRepository.deleteCart(cartId: event.cartId);
      emit(const CartDeleted());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onClear(CartClearEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      // Get all cart items for the customer
      final carts = await cartRepository.getAllCart(customerId: event.customerId);

      // Delete each cart item
      for (final cart in carts) {
        await cartRepository.deleteCart(cartId: cart.cartId);
      }

      emit(const CartCleared());
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  // Clear the cart locally without API calls
  Future<void> _onClearLocal(CartClearLocalEvent event, Emitter<CartState> emit) async {
    emit(const CartInitial());
  }
}
