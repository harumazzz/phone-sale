import 'package:equatable/equatable.dart';

import '../api/order_item_api.dart';
import '../model/request/order_item_request.dart';
import '../model/response/order_item_response.dart';

class OrderItemRepository extends Equatable {
  const OrderItemRepository(this._api);

  final OrderItemApi _api;

  Future<List<OrderItemResponse>> getOrderItems() async {
    return await _api.getOrderItems();
  }

  Future<OrderItemResponse> getOrderItem({required int id}) async {
    return await _api.getOrderItem(id: id);
  }

  Future<void> addOrderItem({required OrderItemRequest request}) async {
    return await _api.addOrderItem(request: request);
  }

  Future<void> editOrderItem({
    required int id,
    required OrderItemRequest request,
  }) async {
    return await _api.editOrderItem(id: id, request: request);
  }

  Future<void> deleteOrderItem({required int id}) async {
    return await _api.deleteOrderItem(id: id);
  }

  @override
  List<Object?> get props => [_api];
}
