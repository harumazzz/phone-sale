import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/product_request.dart';
import '../model/response/product_response.dart';
import '../service/service_locator.dart';

class ProductApi extends Equatable {
  const ProductApi();

  static const endpoint = '/products';

  Future<List<ProductResponse>> getProducts() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      return (response.data as List<dynamic>)
          .map((e) => ProductResponse.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<List<ProductResponse>> getProductsByCategoryId({
    required int id,
  }) async {
    final response = await ServiceLocator.get<Dio>().get(
      '$endpoint/category/$id',
    );
    if (response.statusCode == 200) {
      return (response.data as List<dynamic>)
          .map((e) => ProductResponse.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProductResponse> getProduct({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      return ProductResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addProduct({required ProductRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(
      endpoint,
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> editProduct({
    required int id,
    required ProductRequest request,
  }) async {
    final response = await ServiceLocator.get<Dio>().put(
      '$endpoint/$id',
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> deleteProduct({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
