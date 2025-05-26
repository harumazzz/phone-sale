import 'package:equatable/equatable.dart';

import '../api/discount_api.dart';
import '../model/request/discount_request.dart';
import '../model/response/discount_response.dart';

class DiscountRepository extends Equatable {
  const DiscountRepository({required this.api});

  final DiscountApi api;

  Future<List<DiscountResponse>> getDiscounts() async {
    return api.getDiscounts();
  }

  Future<DiscountResponse> getDiscountById(int id) async {
    return api.getDiscountById(id);
  }

  Future<DiscountResponse> addDiscount(DiscountRequest request) async {
    return api.addDiscount(request);
  }

  Future<DiscountResponse> updateDiscount(int id, DiscountRequest request) async {
    return api.updateDiscount(id, request);
  }

  Future<void> deleteDiscount(int id) async {
    return api.deleteDiscount(id);
  }

  @override
  List<Object?> get props => [api];
}
