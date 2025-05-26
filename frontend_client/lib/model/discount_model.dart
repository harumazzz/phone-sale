enum DiscountType { percentage, fixedAmount }

class DiscountModel {
  const DiscountModel({
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
  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      discountId: json['discountId'] as int?,
      code: json['code'] as String?,
      description: json['description'] as String?,
      discountType:
          json['discountType'] != null
              ? (json['discountType'] == 0 ? DiscountType.percentage : DiscountType.fixedAmount)
              : null,
      discountValue: json['discountValue'] != null ? (json['discountValue'] as num).toDouble() : null,
      minOrderValue: json['minOrderValue'] != null ? (json['minOrderValue'] as num).toDouble() : null,
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
  final DiscountType? discountType;
  final double? discountValue;
  final double? minOrderValue;
  final bool? isActive;
  final DateTime? validFrom;
  final DateTime? validTo;
  final int? maxUses;
  final int? currentUses;
}

class DiscountValidationModel {
  DiscountValidationModel({this.isValid, this.message, this.discountAmount, this.discountId, this.finalPrice});
  factory DiscountValidationModel.fromJson(Map<String, dynamic> json) {
    return DiscountValidationModel(
      isValid: json['isValid'] as bool?,
      message: json['message'] as String?,
      discountAmount: json['discountAmount'] != null ? (json['discountAmount'] as num).toDouble() : null,
      discountId: json['discountId'] as int?,
      finalPrice: json['finalPrice'] != null ? (json['finalPrice'] as num).toDouble() : null,
    );
  }
  final bool? isValid;
  final String? message;
  final double? discountAmount;
  final int? discountId;
  final double? finalPrice;
}
