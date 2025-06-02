class CurrencyUtils {
  static const double _exchangeRate = 25000; // 1 USD = 25,000 VND

  /// Convert USD to VND
  static double convertUsdToVnd(double usdAmount) {
    return usdAmount * _exchangeRate;
  }

  /// Format amount in VND with proper Vietnamese formatting
  static String formatVnd(double usdAmount) {
    final vndAmount = convertUsdToVnd(usdAmount);
    return '${vndAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ₫';
  }
}
