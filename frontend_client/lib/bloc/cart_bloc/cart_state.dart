part of 'cart_bloc.dart';

@immutable
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartLoaded extends CartState {
  const CartLoaded({required this.carts});

  final List<CartItemData> carts;

  bool get isEmpty => carts.isEmpty;

  bool get isNotEmpty => carts.isNotEmpty;

  CartItemData operator [](int index) => carts[index];

  int get size => carts.length;
}

final class CartError extends CartState {
  const CartError({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class CartCleared extends CartState {
  const CartCleared();
}

final class CartDeleted extends CartState {
  const CartDeleted();
}

final class CartAdded extends CartState {
  const CartAdded();
}

final class CartEdited extends CartState {
  const CartEdited();
}
