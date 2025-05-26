import 'package:equatable/equatable.dart';
import 'order_response.dart';
import 'order_item_with_product.dart';

class OrderWithItems extends Equatable {
  const OrderWithItems({required this.order, required this.orderItems});

  final OrderResponse order;
  final List<OrderItemWithProduct> orderItems;

  int get totalItems => orderItems.fold(0, (sum, item) => sum + (item.orderItem.quantity ?? 0));

  @override
  List<Object?> get props => [order, orderItems];
}
