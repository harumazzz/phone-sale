import 'package:equatable/equatable.dart';

class CustomerResponse extends Equatable {
  final int? customerId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? address;
  final String? phoneNumber;

  const CustomerResponse({this.customerId, this.firstName, this.lastName, this.email, this.address, this.phoneNumber});

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      customerId: json['customerId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'address': address,
      'phoneNumber': phoneNumber,
    };
  }

  @override
  List<Object?> get props => [customerId, firstName, lastName, email, address, phoneNumber];
}
