import 'package:equatable/equatable.dart';

class ShipmentRequest extends Equatable {
  final DateTime? shipmentDate;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final int? customerId;

  const ShipmentRequest({
    this.shipmentDate,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.customerId,
  });

  factory ShipmentRequest.fromJson(Map<String, dynamic> json) {
    return ShipmentRequest(
      shipmentDate: json['shipmentDate'] != null ? DateTime.parse(json['shipmentDate']) : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      zipCode: json['zipCode'] as String?,
      customerId: json['customerId'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shipmentDate': shipmentDate?.toIso8601String(),
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'zipCode': zipCode,
      'customerId': customerId,
    };
  }

  @override
  List<Object?> get props => [shipmentDate, address, city, state, country, zipCode, customerId];
}
