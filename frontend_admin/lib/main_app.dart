import 'package:flutter/material.dart';
import 'constant/theme.dart';
import 'screen/auth/login_screen.dart';
import 'screen/dashboard/admin_dashboard.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhoneSale Admin',
      debugShowCheckedModeBanner: false,
      theme: MaterialDesign.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const AdminDashboard(),
      },
    );
  }
}
