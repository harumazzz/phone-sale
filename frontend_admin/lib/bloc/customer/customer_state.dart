part of 'customer_bloc.dart';

sealed class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

final class CustomerInitial extends CustomerState {}

final class CustomerLoading extends CustomerState {}

final class CustomerLoaded extends CustomerState {
  const CustomerLoaded({required this.customers});

  final List<CustomerResponse> customers;

  @override
  List<Object> get props => [customers];
}

final class CustomerError extends CustomerState {
  const CustomerError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
