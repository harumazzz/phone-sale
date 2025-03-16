import 'package:equatable/equatable.dart';

import '../api/product_api.dart';
import '../model/request/product_request.dart';
import '../model/response/product_response.dart';

class ProductRepository extends Equatable {
  const ProductRepository(this._api);

  final ProductApi _api;

  Future<List<ProductResponse>> getProducts() async {
    return await _api.getProducts();
  }

  Future<ProductResponse> getProduct({required int id}) async {
    return await _api.getProduct(id: id);
  }

  Future<void> addProduct({required ProductRequest request}) async {
    return await _api.addProduct(request: request);
  }

  Future<void> editProduct({
    required int id,
    required ProductRequest request,
  }) async {
    return await _api.editProduct(id: id, request: request);
  }

  Future<void> deleteProduct({required int id}) async {
    return await _api.deleteProduct(id: id);
  }

  @override
  List<Object?> get props => [_api];
}
