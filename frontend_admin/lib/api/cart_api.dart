import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/cart_request.dart';
import '../model/response/cart_response.dart';
import '../service/service_locator.dart';

class CartApi extends Equatable {
  const CartApi();

  static const endpoint = '/carts';
  Future<List<CartResponse>> getAllCart({required String customerId}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$customerId');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => CartResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get cart');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => CartResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addCart({required CartRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode == 201 || response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to add to cart');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> editCart({required int cartId, required CartRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$cartId', data: request.toJson());
    if (response.statusCode == 204 || response.statusCode == 200) {
      if (response.statusCode == 200) {
        final apiResponse = response.data as Map<String, dynamic>?;
        if (apiResponse != null && apiResponse['success'] != true) {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to update cart');
        }
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> deleteCart({required int cartId}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$cartId');
    if (response.statusCode == 204 || response.statusCode == 200) {
      if (response.statusCode == 200) {
        final apiResponse = response.data as Map<String, dynamic>?;
        if (apiResponse != null && apiResponse['success'] != true) {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to delete from cart');
        }
      }
    } else {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
