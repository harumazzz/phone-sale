import '../api/discount_api.dart';
import '../model/request/discount_request.dart';
import '../model/response/discount_response.dart';

class DiscountRepository {
  const DiscountRepository(this._api);

  final DiscountApi _api;

  Future<List<DiscountResponse>> getDiscounts() async {
    return _api.getDiscounts();
  }

  Future<DiscountResponse> getDiscountById(int id) async {
    return _api.getDiscountById(id);
  }

  Future<DiscountResponse> addDiscount(DiscountRequest request) async {
    return _api.addDiscount(request);
  }

  Future<DiscountResponse> updateDiscount(int id, DiscountRequest request) async {
    return _api.updateDiscount(id, request);
  }

  Future<void> deleteDiscount(int id) async {
    return _api.deleteDiscount(id);
  }

  Future<DiscountResponse> validateDiscount({
    required String code,
    required double cartTotal,
    required String customerId,
  }) async {
    return _api.validateDiscount(code, cartTotal, customerId);
  }

  List<Object?> get props => [_api];
}
