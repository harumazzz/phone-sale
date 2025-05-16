import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/category_request.dart';
import '../model/response/category_response.dart';
import '../service/service_locator.dart';

class CategoryApi extends Equatable {
  const CategoryApi();

  static const endpoint = '/categories';
  Future<List<CategoryResponse>> getCategories() async {
    final response = await ServiceLocator.get<Dio>().get(endpoint);
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return (apiResponse['data'] as List<dynamic>).map((e) => CategoryResponse.fromJson(e)).toList();
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to get categories');
        }
      } else {
        // Legacy format (direct list)
        return (response.data as List<dynamic>).map((e) => CategoryResponse.fromJson(e)).toList();
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<CategoryResponse> getCategory({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      if (response.data is Map && response.data.containsKey('success')) {
        // New API response format
        final apiResponse = response.data as Map<String, dynamic>;
        if (apiResponse['success'] == true && apiResponse['data'] != null) {
          return CategoryResponse.fromJson(apiResponse['data']);
        } else {
          throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Category not found');
        }
      } else {
        // Legacy format (direct object)
        return CategoryResponse.fromJson(response.data);
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addCategory({required CategoryRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to add category');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> editCategory({required int id, required CategoryRequest request}) async {
    final response = await ServiceLocator.get<Dio>().put('$endpoint/$id', data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to update category');
      }
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> deleteCategory({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>?;
      if (apiResponse != null && apiResponse['success'] != true) {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Failed to delete category');
      }
    } else {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
