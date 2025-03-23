import 'package:equatable/equatable.dart';

import '../api/auth_api.dart';
import '../model/request/login_request.dart';
import '../model/request/register_request.dart';
import '../model/response/customer_response.dart';

class AuthRepository extends Equatable {
  const AuthRepository(this._api);

  final AuthApi _api;

  Future<void> register({required RegisterRequest request}) async {
    return await _api.register(request: request);
  }

  Future<CustomerResponse> login({required LoginRequest request}) async {
    return await _api.login(request: request);
  }

  @override
  List<Object?> get props => [_api];
}
