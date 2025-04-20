import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  const RegisterRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.address,
    this.phoneNumber,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;
  final String? address;
  final String? phoneNumber;

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    address,
    phoneNumber,
  ];
}
