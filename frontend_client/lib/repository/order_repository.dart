import 'package:equatable/equatable.dart';

import '../api/order_api.dart';
import '../model/request/order_request.dart';
import '../model/response/order_response.dart';

class OrderRepository extends Equatable {
  const OrderRepository(this._api);

  final OrderApi _api;

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

  @override
  List<Object?> get props => [_api];
}
