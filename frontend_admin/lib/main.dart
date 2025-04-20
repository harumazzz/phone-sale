import 'package:flutter/material.dart';
import 'package:frontend_admin/service/service_locator.dart';

import 'main_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.registerService();
  runApp(MainApp());
}
