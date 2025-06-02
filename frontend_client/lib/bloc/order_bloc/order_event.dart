part of 'order_bloc.dart';

@immutable
sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class OrderFetchEvent extends OrderEvent {
  const OrderFetchEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

class OrderFetchByCustomerIdEvent extends OrderEvent {
  const OrderFetchByCustomerIdEvent({required this.customerId});

  final String customerId;

  @override
  List<Object?> get props => [customerId];
}

class OrderFetchWithItemsByCustomerIdEvent extends OrderEvent {
  const OrderFetchWithItemsByCustomerIdEvent({required this.customerId});

  final String customerId;

  @override
  List<Object?> get props => [customerId];
}

class OrderAddEvent extends OrderEvent {
  const OrderAddEvent({required this.request});

  final OrderRequest request;

  @override
  List<Object?> get props => [request];
}

class OrderAddWithItemsEvent extends OrderEvent {
  const OrderAddWithItemsEvent({required this.request, required this.cartItems});

  final OrderRequest request;
  final List<dynamic> cartItems; // CartItemData list

  @override
  List<Object?> get props => [request, cartItems];
}

class OrderFetchWithItemsEvent extends OrderEvent {
  const OrderFetchWithItemsEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}

class OrderUpdateStatusEvent extends OrderEvent {
  const OrderUpdateStatusEvent({required this.orderId, required this.status});

  final int orderId;
  final int status;

  @override
  List<Object?> get props => [orderId, status];
}
