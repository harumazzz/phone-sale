import 'package:equatable/equatable.dart';
import '../api/forgot_password_api.dart';

class ForgotPasswordRepository extends Equatable {
  const ForgotPasswordRepository({required this.api});

  final ForgotPasswordApi api;

  @override
  List<Object?> get props => [api];

  Future<void> forgotPassword({required String email}) async {
    return api.forgotPassword(request: ForgotPasswordRequest(email: email));
  }
}
