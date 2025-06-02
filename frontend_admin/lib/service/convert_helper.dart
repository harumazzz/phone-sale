import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import '../utils/currency_utils.dart';

class ConvertHelper {
  const ConvertHelper._();

  static double convertUsdToVnd(double usdAmount, double exchangeRate) {
    return CurrencyUtils.convertUsdToVnd(usdAmount);
  }

  static String inVND(double priceInUsd, [double exchangeRate = 25000]) {
    return CurrencyUtils.formatVnd(priceInUsd);
  }

  static Widget exchangeSymbols(String value) {
    return switch (value) {
      'Android' => const Icon(Symbols.android, color: Colors.green),
      'iPhones' => const Icon(Symbols.ios, color: Colors.grey),
      'Gaming' => const Icon(Symbols.gamepad, color: Colors.blue),
      _ => const Icon(Symbols.smartphone),
    };
  }
}
