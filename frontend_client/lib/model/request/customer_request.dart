import 'package:equatable/equatable.dart';

class CustomerRequest extends Equatable {
  const CustomerRequest({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.address,
    this.phoneNumber,
  });

  factory CustomerRequest.fromJson(Map<String, dynamic> json) {
    return CustomerRequest(
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
