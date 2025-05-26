import 'package:equatable/equatable.dart';

class DiscountResponse extends Equatable {
  const DiscountResponse({
    this.discountId,
    this.code,
    this.description,
    this.discountType,
    this.discountValue,
    this.minOrderValue,
    this.isActive,
    this.validFrom,
    this.validTo,
    this.maxUses,
    this.currentUses,
  });

  factory DiscountResponse.fromJson(Map<String, dynamic> json) {
    return DiscountResponse(
      discountId: json['discountId'] as int?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      discountType: json['discountType'] as int?,
      discountValue: json['discountValue'] as double?,
      minOrderValue: json['minOrderValue'] as double?,
      isActive: json['isActive'] as bool?,
      validFrom: json['validFrom'] != null ? DateTime.parse(json['validFrom'] as String) : null,
      validTo: json['validTo'] != null ? DateTime.parse(json['validTo'] as String) : null,
      maxUses: json['maxUses'] as int?,
      currentUses: json['currentUses'] as int?,
    );
  }

  final int? discountId;
  final String? code;
  final String? description;
  final int? discountType; // 0 = Percentage, 1 = FixedAmount
  final double? discountValue;
  final double? minOrderValue;
  final bool? isActive;
  final DateTime? validFrom;
  final DateTime? validTo;
  final int? maxUses;
  final int? currentUses;

  String get discountTypeText {
    switch (discountType) {
      case 0:
        return 'Phần trăm';
      case 1:
        return 'Số tiền cố định';
      default:
        return 'Không xác định';
    }
  }

  String get statusText => isActive == true ? 'Hoạt động' : 'Không hoạt động';

  Map<String, dynamic> toJson() {
    return {
      'discountId': discountId,
      'code': code,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'isActive': isActive,
      'validFrom': validFrom?.toIso8601String(),
      'validTo': validTo?.toIso8601String(),
      'maxUses': maxUses,
      'currentUses': currentUses,
    };
  }

  @override
  List<Object?> get props => [
    discountId,
    code,
    description,
    discountType,
    discountValue,
    minOrderValue,
    isActive,
    validFrom,
    validTo,
    maxUses,
    currentUses,
  ];
}
