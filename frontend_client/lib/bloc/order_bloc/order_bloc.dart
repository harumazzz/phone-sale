import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/order_repository.dart';
import '../../model/response/order_response.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({required this.orderRepository}) : super(const OrderInitial()) {
    on<LoadOrderEvent>(_onLoad);
  }

  final OrderRepository orderRepository;

  Future<void> _onLoad(LoadOrderEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final orders = await orderRepository.getOrdersByCustomerId(customerId: event.customerId);
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}
