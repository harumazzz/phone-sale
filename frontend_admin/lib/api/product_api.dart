import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/api_response.dart';
import '../model/request/product_request.dart';
import '../model/response/product_response.dart';
import '../service/service_locator.dart';

class ProductApi extends Equatable {
  const ProductApi();

  static const endpoint = '/products';
  Future<List<ProductResponse>> getProducts() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format with ApiResponse wrapper
        final apiResponse = ApiResponse.listFromJson(response.data as Map<String, dynamic>, ProductResponse.fromJson);

        if (!apiResponse.success) {
          throw Exception(apiResponse.message);
        }

        return apiResponse.data ?? [];
      } else {
        // Legacy format (direct list)
        final apiResponse = ApiResponse.fromDirectList(response.data as List<dynamic>, ProductResponse.fromJson);

        return apiResponse.data ?? [];
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<List<ProductResponse>> getProductsByCategoryId({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/category/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format with ApiResponse wrapper
        final apiResponse = ApiResponse.listFromJson(response.data as Map<String, dynamic>, ProductResponse.fromJson);

        if (!apiResponse.success) {
          throw Exception(apiResponse.message);
        }

        return apiResponse.data ?? [];
      } else {
        // Legacy format (direct list)
        final apiResponse = ApiResponse.fromDirectList(response.data as List<dynamic>, ProductResponse.fromJson);

        return apiResponse.data ?? [];
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<List<ProductResponse>> getProductsByName({required String name}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/search', queryParameters: {'searchQuery': name});
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => ProductResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to search products');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => ProductResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<ProductResponse> getProduct({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return ProductResponse.fromJson(apiResponse['data']);
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Product not found');
        }
      } else {
        // Legacy format (direct object)
        return ProductResponse.fromJson(response.data);
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addProduct({required ProductRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to add product');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> editProduct({required int id, required ProductRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to update product');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> deleteProduct({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to delete product');
      }
    } else {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
