import 'package:equatable/equatable.dart';

class DiscountRequest extends Equatable {
  const DiscountRequest({
    this.code,
    this.description,
    this.discountType,
    this.discountValue,
    this.minOrderValue,
    this.isActive,
    this.validFrom,
    this.validTo,
    this.maxUses,
  });

  factory DiscountRequest.fromJson(Map<String, dynamic> json) {
    return DiscountRequest(
      code: json['code'] as String?,
      description: json['description'] as String?,
      discountType: json['discountType'] as int?,
      discountValue: json['discountValue'] as double?,
      minOrderValue: json['minOrderValue'] as double?,
      isActive: json['isActive'] as bool?,
      validFrom: json['validFrom'] != null ? DateTime.parse(json['validFrom'] as String) : null,
      validTo: json['validTo'] != null ? DateTime.parse(json['validTo'] as String) : null,
      maxUses: json['maxUses'] as int?,
    );
  }

  final String? code;
  final String? description;
  final int? discountType; // 0 = Percentage, 1 = FixedAmount
  final double? discountValue;
  final double? minOrderValue;
  final bool? isActive;
  final DateTime? validFrom;
  final DateTime? validTo;
  final int? maxUses;

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'isActive': isActive,
      'validFrom': validFrom?.toIso8601String(),
      'validTo': validTo?.toIso8601String(),
      'maxUses': maxUses,
    };
  }

  @override
  List<Object?> get props => [
    code,
    description,
    discountType,
    discountValue,
    minOrderValue,
    isActive,
    validFrom,
    validTo,
    maxUses,
  ];
}
