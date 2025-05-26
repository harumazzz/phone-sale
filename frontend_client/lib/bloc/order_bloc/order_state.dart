part of 'order_bloc.dart';

@immutable
sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

final class OrderInitial extends OrderState {
  const OrderInitial();
}

final class OrderLoading extends OrderState {
  const OrderLoading();
}

final class OrderLoaded extends OrderState {
  const OrderLoaded({required this.orders});
  final List<OrderResponse> orders;

  @override
  List<Object?> get props => [orders];
}

final class OrderWithItemsLoaded extends OrderState {
  const OrderWithItemsLoaded({required this.ordersWithItems});
  final List<OrderWithItems> ordersWithItems;

  @override
  List<Object?> get props => [ordersWithItems];
}

final class OrderDetailLoaded extends OrderState {
  const OrderDetailLoaded({required this.order});
  final OrderResponse order;

  @override
  List<Object?> get props => [order];
}

final class OrderAdded extends OrderState {
  const OrderAdded({required this.orderId});
  final int orderId;

  @override
  List<Object?> get props => [orderId];
}

final class OrderStatusUpdated extends OrderState {
  const OrderStatusUpdated({required this.orderId, required this.newStatus});

  final int orderId;
  final int newStatus;

  @override
  List<Object?> get props => [orderId, newStatus];
}

final class OrderError extends OrderState {
  const OrderError({required this.message});
  final String message;

  @override
  List<Object?> get props => [message];
}
