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
      return (response.data as List<dynamic>)
          .map((e) => CategoryResponse.fromJson(e))
          .toList();
    } else {
      throw Exception(response.data);
    }
  }

  Future<CategoryResponse> getCategory({required int id}) async {
    final response = await ServiceLocator.get<Dio>().get('$endpoint/$id');
    if (response.statusCode == 200) {
      return CategoryResponse.fromJson(response.data);
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> addCategory({required CategoryRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(
      endpoint,
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> editCategory({
    required int id,
    required CategoryRequest request,
  }) async {
    final response = await ServiceLocator.get<Dio>().put(
      '$endpoint/$id',
      data: request.toJson(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  Future<void> deleteCategory({required int id}) async {
    final response = await ServiceLocator.get<Dio>().delete('$endpoint/$id');
    if (response.statusCode != 200) {
      throw Exception(response.data);
    }
  }

  @override
  List<Object?> get props => [];
}
