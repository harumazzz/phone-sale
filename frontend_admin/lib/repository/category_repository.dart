import 'package:equatable/equatable.dart';

import '../api/category_api.dart';
import '../model/request/category_request.dart';
import '../model/response/category_response.dart';

class CategoryRepository extends Equatable {
  const CategoryRepository(this._api);

  final CategoryApi _api;

  Future<List<CategoryResponse>> getCategories() async {
    return await _api.getCategories();
  }

  Future<CategoryResponse> getCategory({required int id}) async {
    return await _api.getCategory(id: id);
  }

  Future<void> addCategory({required CategoryRequest request}) async {
    return await _api.addCategory(request: request);
  }

  Future<void> editCategory({
    required int id,
    required CategoryRequest request,
  }) async {
    return await _api.editCategory(id: id, request: request);
  }

  Future<void> deleteCategory({required int id}) async {
    return await _api.deleteCategory(id: id);
  }

  @override
  List<Object?> get props => [_api];
}
