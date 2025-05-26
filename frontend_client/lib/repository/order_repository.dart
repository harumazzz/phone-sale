import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../api/order_api.dart';
import '../api/order_item_api.dart';
import '../api/product_api.dart';
import '../model/request/order_request.dart';
import '../model/response/order_response.dart';
import '../model/response/order_item_with_product.dart';
import '../model/response/order_with_items.dart';

class OrderRepository extends Equatable {
  const OrderRepository(this._api, this._orderItemApi, this._productApi);

  final OrderApi _api;
  final OrderItemApi _orderItemApi;
  final ProductApi _productApi;

  Future<List<OrderResponse>> getOrders() async {
    return await _api.getOrders();
  }

  Future<List<OrderResponse>> getOrdersByCustomerId({required String customerId}) async {
    return await _api.getOrdersByCustomerId(customerId: customerId);
  }

  Future<OrderResponse> getOrder({required int id}) async {
    return await _api.getOrder(id: id);
  }

  Future<int> addOrder({required OrderRequest request}) async {
    return await _api.addOrder(request: request);
  }

  Future<void> editOrder({required int id, required OrderRequest request}) async {
    return await _api.editOrder(id: id, request: request);
  }

  Future<void> deleteOrder({required int id}) async {
    return await _api.deleteOrder(id: id);
  }

  Future<List<OrderWithItems>> getOrdersWithItemsByCustomerId({required String customerId}) async {
    final orders = await _api.getOrdersByCustomerId(customerId: customerId);
    final List<OrderWithItems> ordersWithItems = [];

    for (final order in orders) {
      if (order.orderId != null) {
        try {
          final orderItems = await _orderItemApi.getOrderItemsByOrderId(orderId: order.orderId!);
          final List<OrderItemWithProduct> itemsWithProducts = [];

          for (final orderItem in orderItems) {
            if (orderItem.productId != null) {
              try {
                final product = await _productApi.getProduct(id: orderItem.productId!);
                itemsWithProducts.add(OrderItemWithProduct(orderItem: orderItem, product: product));
              } catch (e) {
                // If product fetch fails, skip this item
                debugPrint('Failed to fetch product ${orderItem.productId}: $e');
              }
            }
          }

          ordersWithItems.add(OrderWithItems(order: order, orderItems: itemsWithProducts));
        } catch (e) {
          // If order items fetch fails, add order without items
          debugPrint('Failed to fetch order items for order ${order.orderId}: $e');
          ordersWithItems.add(OrderWithItems(order: order, orderItems: const []));
        }
      }
    }

    return ordersWithItems;
  }

  @override
  List<Object?> get props => [_api, _orderItemApi, _productApi];
}
