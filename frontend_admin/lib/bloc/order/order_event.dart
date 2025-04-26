part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrderEvent extends OrderEvent {
  const LoadOrderEvent();
}

class AddOrderEvent extends OrderEvent {
  const AddOrderEvent({required this.request});

  final OrderRequest request;

  @override
  List<Object?> get props => [request];
}

class EditOrderEvent extends OrderEvent {
  const EditOrderEvent({required this.id, required this.request});

  final int id;
  final OrderRequest request;

  @override
  List<Object?> get props => [id, request];
}

class DeleteOrderEvent extends OrderEvent {
  const DeleteOrderEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
