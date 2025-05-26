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
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => OrderResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get orders');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => OrderResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<List<OrderResponse>> getOrdersByCustomerId({required String customerId}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/customer/$customerId');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => OrderResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get customer orders');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => OrderResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<OrderResponse> getOrder({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return OrderResponse.fromJson(apiResponse['data']);
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Order not found');
        }
      } else {
        // Legacy format (direct object)
        return OrderResponse.fromJson(response.data);
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<int> addOrder({required OrderRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());

    if (response.statusCode == 201) {
      if (response.data is Map<String, dynamic> && response.data.containsKey('success')) {
        final apiResponse = response.data as Map<String, dynamic>;

        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          // Try to get orderId from data object
          if (apiResponse['data'] is Map<String, dynamic>) {
            final dataMap = apiResponse['data'] as Map<String, dynamic>;

            // Try different case variations for orderId
            final orderId = dataMap['orderId'] ?? dataMap['OrderId'] ?? dataMap['orderid'] ?? -1;

            if (orderId != -1) {
              return orderId is int ? orderId : int.tryParse(orderId.toString()) ?? -1;
            }
            return -1;
          } else if (apiResponse['data'] is int) {
            return apiResponse['data'];
          }
          return -1;
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to create order');
        }
      } else if (response.data is Map<String, dynamic>) {
        // Legacy format
        return response.data['orderId'] ?? -1;
      } else if (response.data is int) {
        return response.data;
      }
      return -1;
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> editOrder({required int id, required OrderRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to update order');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> deleteOrder({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to delete order');
      }
    } else {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
