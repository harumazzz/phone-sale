import 'package:equatable/equatable.dart';

class ShipmentResponse extends Equatable {
  const ShipmentResponse({
    this.shipmentId,
    this.shipmentDate,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipCode,
    this.customerId,
  });

  factory ShipmentResponse.fromJson(Map<String, dynamic> json) {
    return ShipmentResponse(
      shipmentId: json['shipmentId'] as int?,
      shipmentDate:
          json['shipmentDate'] != null
              ? DateTime.parse(json['shipmentDate'])
              : null,
      address: json['address'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      country: json['country'] as String?,
      zipCode: json['zipCode'] as String?,
      customerId: json['customerId'],
    );
  }
  final int? shipmentId;
  final DateTime? shipmentDate;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? zipCode;
  final String? customerId;

  Map<String, dynamic> toJson() {
    return {
      'shipmentId': shipmentId,
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
  List<Object?> get props => [
    shipmentId,
    shipmentDate,
    address,
    city,
    state,
    country,
    zipCode,
    customerId,
  ];
}
