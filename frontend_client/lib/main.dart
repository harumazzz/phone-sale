import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'application.dart';
import 'constant/system_overlay.dart';
import 'service/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(SystemOverlay.kDefaultOverlay);
  ServiceLocator.registerService();
  runApp(const Application());
}
