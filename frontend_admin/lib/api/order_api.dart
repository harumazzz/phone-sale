import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/order_request.dart';
import '../model/response/order_response.dart';
import '../service/service_locator.dart';

class OrderApi extends Equatable {
  const OrderApi();

  static const endpoint = '/orders';

  Future<List<OrderResponse>> getOrders() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      return (response.data as List<dynamic>).map((e) => OrderResponse.fromJson(e)).toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<OrderResponse> getOrder({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      return OrderResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addOrder({required OrderRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode != 201) {
      throw Exception(response.data);
    }
  }

  Future<void> editOrder({required int id, required OrderRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode != 204) {
      throw Exception(response.data);
    }
  }

  Future<void> deleteOrder({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 204) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
