import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {
  final String? email;
  final String? password;

  const LoginRequest({this.email, this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  @override
  List<Object?> get props => [email, password];
}
