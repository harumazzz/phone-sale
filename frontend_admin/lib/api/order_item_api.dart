import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/order_item_request.dart';
import '../model/response/order_item_response.dart';
import '../service/service_locator.dart';

class OrderItemApi extends Equatable {
  const OrderItemApi();

  static const endpoint = '/order-items';

  Future<List<OrderItemResponse>> getOrderItems() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      return (response.data as List<dynamic>)
          .map((e) => OrderItemResponse.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<OrderItemResponse> getOrderItem({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      return OrderItemResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addOrderItem({required OrderItemRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(
      endpoint,
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> editOrderItem({
    required int id,
    required OrderItemRequest request,
  }) async {
    final response = await ServiceLocator.get<Dio>().put(
      '$endpoint/$id',
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> deleteOrderItem({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
