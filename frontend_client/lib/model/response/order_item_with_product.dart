import 'package:equatable/equatable.dart';
import 'order_item_response.dart';
import 'product_response.dart';

class OrderItemWithProduct extends Equatable {
  const OrderItemWithProduct({required this.orderItem, required this.product});

  final OrderItemResponse orderItem;
  final ProductResponse product;

  @override
  List<Object?> get props => [orderItem, product];
}
