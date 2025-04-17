part of 'cart_bloc.dart';

@immutable
sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class CartLoadEvent extends CartEvent {
  const CartLoadEvent({required this.customerId});
  final String customerId;

  @override
  List<Object?> get props => [customerId];
}

final class CartAddEvent extends CartEvent {
  const CartAddEvent({
    required this.customerId,
    required this.productId,
    required this.quantity,
  });
  final String customerId;
  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [customerId, productId, quantity];
}

final class CartEditEvent extends CartEvent {
  const CartEditEvent({
    required this.cartId,
    required this.customerId,
    required this.productId,
    required this.quantity,
  });
  final int cartId;
  final String customerId;
  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [cartId, customerId, productId, quantity];
}

final class CartDeleteEvent extends CartEvent {
  const CartDeleteEvent({required this.cartId});
  final int cartId;

  @override
  List<Object?> get props => [cartId];
}
