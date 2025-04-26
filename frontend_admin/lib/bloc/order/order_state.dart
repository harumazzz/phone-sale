part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderLoaded extends OrderState {
  const OrderLoaded({required this.orders});

  final List<OrderResponse> orders;

  @override
  List<Object> get props => [orders];
}

final class OrderError extends OrderState {
  const OrderError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
