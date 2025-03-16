import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../model/request/login_request.dart';
import '../model/request/register_request.dart';
import '../service/service_locator.dart';

class AuthApi extends Equatable {
  const AuthApi();

  static const endpoint = '/auth';

  @override
  List<Object?> get props => [];

  Future<void> register({required RegisterRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(
      '$endpoint/register',
      data: request.toJson(),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.data);
    }
  }

  Future<void> login({required LoginRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(
      '$endpoint/login',
      data: request.toJson(),
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception(response.data);
    }
  }
}
