part of 'order_bloc.dart';

@immutable
sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderEvent extends OrderEvent {
  const LoadOrderEvent({required this.customerId});

  final String customerId;

  @override
  List<Object?> get props => [customerId];
}
