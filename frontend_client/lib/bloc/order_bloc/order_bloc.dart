import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/order_repository.dart';
import '../../model/response/order_response.dart';
import '../../model/response/order_with_items.dart';
import '../../model/request/order_request.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({required this.orderRepository}) : super(const OrderInitial()) {
    on<OrderFetchEvent>(_onFetchOrder);
    on<OrderFetchByCustomerIdEvent>(_onFetchOrdersByCustomerId);
    on<OrderFetchWithItemsByCustomerIdEvent>(_onFetchOrdersWithItemsByCustomerId);
    on<OrderAddEvent>(_onAddOrder);
    on<OrderUpdateStatusEvent>(_onUpdateOrderStatus);
  }

  final OrderRepository orderRepository;

  Future<void> _onFetchOrder(OrderFetchEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final order = await orderRepository.getOrder(id: event.id);
      emit(OrderDetailLoaded(order: order));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onFetchOrdersByCustomerId(OrderFetchByCustomerIdEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final orders = await orderRepository.getOrdersByCustomerId(customerId: event.customerId);
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onFetchOrdersWithItemsByCustomerId(
    OrderFetchWithItemsByCustomerIdEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());
    try {
      final ordersWithItems = await orderRepository.getOrdersWithItemsByCustomerId(customerId: event.customerId);
      emit(OrderWithItemsLoaded(ordersWithItems: ordersWithItems));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onAddOrder(OrderAddEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final orderId = await orderRepository.addOrder(request: event.request);

      if (orderId > 0) {
        emit(OrderAdded(orderId: orderId));
      } else {
        emit(const OrderError(message: 'Failed to create order: Invalid order ID returned'));
      }
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onUpdateOrderStatus(OrderUpdateStatusEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      // Get the current order
      final order = await orderRepository.getOrder(id: event.orderId);

      // Update order status
      final updatedRequest = OrderRequest(
        customerId: order.customerId,
        totalPrice: order.totalPrice,
        status: event.status,
      );

      await orderRepository.editOrder(id: event.orderId, request: updatedRequest);
      emit(OrderStatusUpdated(orderId: event.orderId, newStatus: event.status));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}
