import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/cart_request.dart';
import '../model/response/cart_response.dart';
import '../service/service_locator.dart';

class CartApi extends Equatable {
  const CartApi();

  static const endpoint = '/carts';

  Future<List<CartResponse>> getAllCart({required String customerId}) async {
    final response = await ServiceLocator.get<Dio>().get(
      '$endpoint/$customerId',
    );
    if (response.statusCode == 200) {
      return (response.data as List<dynamic>)
          .map((e) => CartResponse.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addCart({required CartRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(
      endpoint,
      data: request.toJson(),
    );
    if (response.statusCode != 201) {
      throw Exception(response.data);
    }
  }

  Future<void> editCart({
    required int cartId,
    required CartRequest request,
  }) async {
    final response = await ServiceLocator.get<Dio>().put(
      '$endpoint/$cartId',
      data: request.toJson(),
    );
    if (response.statusCode != 204) {
      throw Exception(response.data);
    }
  }

  Future<void> deleteCart({required int cartId}) async {
    final response = await ServiceLocator.get<Dio>().delete(
      '$endpoint/$cartId',
    );
    if (response.statusCode != 204) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
