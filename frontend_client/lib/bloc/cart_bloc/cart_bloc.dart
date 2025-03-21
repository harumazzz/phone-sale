import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/cart_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required this.cartRepository}) : super(const CartInitial()) {
    on<CartEvent>(_onLoad);
  }

  final CartRepository cartRepository;

  Future<void> _onLoad(CartEvent event, Emitter<CartState> emit) async {
    // TODO: implement event handler
  }
}
