import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

import '../service/service_locator.dart';

class ForgotPasswordRequest extends Equatable {
  const ForgotPasswordRequest({this.email});

  factory ForgotPasswordRequest.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordRequest(email: json['email']);
  }
  final String? email;

  Map<String, dynamic> toJson() {
    return {'email': email};
  }

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordApi extends Equatable {
  const ForgotPasswordApi();

  static const endpoint = 'auth/forgot-password';

  @override
  List<Object?> get props => [];

  Future<void> forgotPassword({required ForgotPasswordRequest request}) async {
    final response = await ServiceLocator.get<Dio>().post(endpoint, data: request.toJson());
    if (response.statusCode == 200) {
      final apiResponse = response.data as Map<String, dynamic>;
      if (apiResponse['success'] == true) {
        return;
      } else {
        throw Exception(apiResponse['message'] ?? apiResponse['error'] ?? 'Password reset request failed');
      }
    } else {
      throw Exception(response.data);
    }
  }
}
