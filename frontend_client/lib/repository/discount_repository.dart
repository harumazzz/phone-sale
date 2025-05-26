import '../api/discount_api.dart';
import '../model/discount_model.dart';

class DiscountRepository {
  const DiscountRepository(this._discountApi);
  final DiscountApi _discountApi;

  Future<DiscountValidationModel> validateDiscount({
    required String code,
    required double cartTotal,
    required String customerId,
  }) async {
    return _discountApi.validateDiscount(code: code, cartTotal: cartTotal, customerId: customerId);
  }

  Future<List<DiscountModel>> getDiscounts() async {
    return _discountApi.getDiscounts();
  }
}
