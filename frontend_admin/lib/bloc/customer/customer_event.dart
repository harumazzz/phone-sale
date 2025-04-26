part of 'customer_bloc.dart';

sealed class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];
}

class LoadCustomerEvent extends CustomerEvent {
  const LoadCustomerEvent();
}

class AddCustomerEvent extends CustomerEvent {
  const AddCustomerEvent({required this.request});

  final CustomerRequest request;

  @override
  List<Object?> get props => [request];
}

class EditCustomerEvent extends CustomerEvent {
  const EditCustomerEvent({required this.id, required this.request});

  final int id;
  final CustomerRequest request;

  @override
  List<Object?> get props => [id, request];
}

class DeleteCustomerEvent extends CustomerEvent {
  const DeleteCustomerEvent({required this.id});

  final int id;

  @override
  List<Object?> get props => [id];
}
