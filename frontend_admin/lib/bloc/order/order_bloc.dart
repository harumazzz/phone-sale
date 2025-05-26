import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/request/order_request.dart';
import '../../model/response/order_response.dart';
import '../../repository/order_repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({required this.orderRepository}) : super(OrderInitial()) {
    on<LoadOrderEvent>(_onLoadOrderEvent);
    on<AddOrderEvent>(_onAddOrderEvent);
    on<EditOrderEvent>(_onEditOrderEvent);
    on<DeleteOrderEvent>(_onDeleteOrderEvent);
    on<UpdateOrderEvent>(_onUpdateOrderEvent);
  }

  final OrderRepository orderRepository;

  Future<void> _onLoadOrderEvent(LoadOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await orderRepository.getOrders();
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onAddOrderEvent(AddOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await orderRepository.addOrder(request: event.request);
      final orders = await orderRepository.getOrders();
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onEditOrderEvent(EditOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await orderRepository.editOrder(id: event.id, request: event.request);
      final orders = await orderRepository.getOrders();
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onDeleteOrderEvent(DeleteOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await orderRepository.deleteOrder(id: event.id);
      final orders = await orderRepository.getOrders();
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onUpdateOrderEvent(UpdateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      await orderRepository.editOrder(id: event.orderId, request: event.orderRequest);
      emit(const OrderUpdated(message: 'Cập nhật đơn hàng thành công'));
      final orders = await orderRepository.getOrders();
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}
