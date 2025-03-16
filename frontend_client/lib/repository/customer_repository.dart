import 'package:equatable/equatable.dart';

import '../api/customer_api.dart';
import '../model/request/customer_request.dart';
import '../model/response/customer_response.dart';

class CustomerRepository extends Equatable {
  const CustomerRepository(this._api);

  final CustomerApi _api;

  Future<List<CustomerResponse>> getCustomers() async {
    return await _api.getCustomers();
  }

  Future<CustomerResponse> getCustomer({required int id}) async {
    return await _api.getCustomer(id: id);
  }

  Future<void> addCustomer({required CustomerRequest request}) async {
    return await _api.addCustomer(request: request);
  }

  Future<void> editCustomer({
    required int id,
    required CustomerRequest request,
  }) async {
    return await _api.editCustomer(id: id, request: request);
  }

  Future<void> deleteCustomer({required int id}) async {
    return await _api.deleteCustomer(id: id);
  }

  @override
  List<Object?> get props => [_api];
}
