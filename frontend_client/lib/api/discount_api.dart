import 'package:dio/dio.dart';

import '../model/discount_model.dart';
import '../service/service_locator.dart';

class DiscountApi {
  const DiscountApi();

  Future<DiscountValidationModel> validateDiscount({
    required String code,
    required double cartTotal,
    required String customerId,
  }) async {
    try {
      final response = await ServiceLocator.get<Dio>().post(
        '/discounts/validate',
        data: {'code': code, 'cartTotal': cartTotal, 'customerId': customerId},
      );

      if (response.data['isSuccess'] && response.data['data'] != null) {
        return DiscountValidationModel.fromJson(response.data['data']);
      }

      throw Exception(response.data['message'] ?? 'Failed to validate discount code');
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null && e.response!.data['message'] != null) {
        throw Exception(e.response!.data['message']);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error validating discount code: $e');
    }
  }

  Future<List<DiscountModel>> getDiscounts() async {
    try {
      final response = await ServiceLocator.get<Dio>().get('/discounts');

      if (response.data['isSuccess'] && response.data['data'] != null) {
        final List<dynamic> discountsJson = response.data['data'];
        return discountsJson.map((json) => DiscountModel.fromJson(json)).toList();
      }

      throw Exception(response.data['message'] ?? 'Failed to get discounts');
    } on DioException catch (e) {
      if (e.response != null && e.response!.data != null && e.response!.data['message'] != null) {
        throw Exception(e.response!.data['message']);
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Error getting discounts: $e');
    }
  }
}
