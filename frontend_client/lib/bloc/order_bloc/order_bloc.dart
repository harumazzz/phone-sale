import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../repository/order_repository.dart';
import '../../model/response/order_response.dart';
import '../../model/response/order_with_items.dart';
import '../../model/request/order_request.dart';
import '../../api/order_item_api.dart';
import '../../model/request/order_item_request.dart';
import '../../model/cart_item_data.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc({required this.orderRepository}) : super(const OrderInitial()) {
    on<OrderFetchEvent>(_onFetchOrder);
    on<OrderFetchWithItemsEvent>(_onFetchOrderWithItems);
    on<OrderFetchByCustomerIdEvent>(_onFetchOrdersByCustomerId);
    on<OrderFetchWithItemsByCustomerIdEvent>(_onFetchOrdersWithItemsByCustomerId);
    on<OrderAddEvent>(_onAddOrder);
    on<OrderAddWithItemsEvent>(_onAddOrderWithItems);
    on<OrderUpdateStatusEvent>(_onUpdateOrderStatus);
  }

  final OrderRepository orderRepository;
  final OrderItemApi _orderItemApi = const OrderItemApi();

  Future<void> _onFetchOrder(OrderFetchEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final order = await orderRepository.getOrder(id: event.id);
      emit(OrderDetailLoaded(order: order));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }

  Future<void> _onFetchOrderWithItems(OrderFetchWithItemsEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      final orderWithItems = await orderRepository.getOrderWithItems(id: event.id);
      emit(OrderDetailWithItemsLoaded(orderWithItems: orderWithItems));
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

  Future<void> _onAddOrderWithItems(OrderAddWithItemsEvent event, Emitter<OrderState> emit) async {
    emit(const OrderLoading());
    try {
      // First, create the order
      final orderId = await orderRepository.addOrder(request: event.request);

      if (orderId <= 0) {
        emit(const OrderError(message: 'Failed to create order: Invalid order ID returned'));
        return;
      }

      // Then, create order items for each cart item
      for (final cartItemData in event.cartItems) {
        if (cartItemData is CartItemData) {
          final orderItemRequest = OrderItemRequest(
            orderId: orderId,
            productId: cartItemData.productId,
            quantity: cartItemData.quantity,
            price: cartItemData.product.price,
          );

          await _orderItemApi.addOrderItem(request: orderItemRequest);
        }
      }

      emit(OrderAdded(orderId: orderId));
    } catch (e) {
      emit(OrderError(message: e.toString()));
    }
  }
}
