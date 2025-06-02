class CurrencyUtils {
  // Tỷ giá USD to VND
  static const double exchangeRate = 25000.0;

  /// Chuyển đổi từ USD sang VND
  static double? usdToVnd(double? usdAmount) {
    return usdAmount != null ? usdAmount * exchangeRate : null;
  }

  /// Chuyển đổi từ VND sang USD
  static double? vndToUsd(double? vndAmount) {
    return vndAmount != null ? vndAmount / exchangeRate : null;
  }

  /// Format số tiền VND với dấu phẩy và ký hiệu ₫
  static String formatVnd(double? amount) {
    if (amount == null) {
      return '0 ₫';
    }
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫';
  }

  /// Chuyển đổi và format USD sang VND
  static String formatUsdToVnd(double? usdAmount) {
    final vndAmount = usdToVnd(usdAmount);
    return formatVnd(vndAmount);
  }

  /// Format số tiền USD
  static String formatUsd(double? amount) {
    if (amount == null) {
      return '\$0.00';
    }
    return '\$${amount.toStringAsFixed(2)}';
  }
}
