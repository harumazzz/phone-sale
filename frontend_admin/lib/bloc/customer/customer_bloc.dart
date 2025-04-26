import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/request/customer_request.dart';
import '../../model/response/customer_response.dart';
import '../../repository/customer_repository.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  CustomerBloc({required this.customerRepository}) : super(CustomerInitial()) {
    on<LoadCustomerEvent>(_onLoadCustomerEvent);
    on<AddCustomerEvent>(_onAddCustomerEvent);
    on<EditCustomerEvent>(_onEditCustomerEvent);
    on<DeleteCustomerEvent>(_onDeleteCustomerEvent);
  }

  final CustomerRepository customerRepository;

  Future<void> _onLoadCustomerEvent(LoadCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final customers = await customerRepository.getCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(message: e.toString()));
    }
  }

  Future<void> _onAddCustomerEvent(AddCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      await customerRepository.addCustomer(request: event.request);
      final customers = await customerRepository.getCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(message: e.toString()));
    }
  }

  Future<void> _onEditCustomerEvent(EditCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      await customerRepository.editCustomer(id: event.id, request: event.request);
      final customers = await customerRepository.getCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(message: e.toString()));
    }
  }

  Future<void> _onDeleteCustomerEvent(DeleteCustomerEvent event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      await customerRepository.deleteCustomer(id: event.id);
      final customers = await customerRepository.getCustomers();
      emit(CustomerLoaded(customers: customers));
    } catch (e) {
      emit(CustomerError(message: e.toString()));
    }
  }
}
