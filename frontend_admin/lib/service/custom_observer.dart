import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  CustomNavigatorObserver({required this.onPop});

  final void Function() onPop;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    onPop();
  }
}
