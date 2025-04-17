import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../model/request/cart_request.dart';
import '../../model/response/cart_response.dart';
import '../../repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.cartRepository}) : super(const CartInitial()) {
    on<CartLoadEvent>(_onLoad);
    on<CartAddEvent>(_onAdd);
    on<CartEditEvent>(_onEdit);
    on<CartDeleteEvent>(_onDelete);
  }

  final CartRepository cartRepository;

  Future<void> _onLoad(CartLoadEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final result = await cartRepository.getAllCart(
        customerId: event.customerId,
      );
      emit(CartLoaded(carts: result));
    } catch (e) {
      emit(CartError(message: e.toString()));
    }
  }

  Future<void> _onAdd(CartAddEvent event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      await cartRepository.addCart(
        request: CartRequest(
          customerId: event.customerId,
          productId: event.productId,
          quantity: event.quantity,
        ),
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
        request: CartRequest(
          customerId: event.customerId,
          productId: event.productId,
          quantity: event.quantity,
        ),
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
}
