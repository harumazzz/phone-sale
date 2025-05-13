import 'package:flutter/material.dart';
import 'package:frontend_admin/screen/category/category_screen.dart';
import 'package:frontend_admin/screen/customer/customer_screen.dart';
import 'package:frontend_admin/screen/home/home_screen.dart';
import 'package:frontend_admin/screen/order/order_screen.dart';
import 'package:frontend_admin/screen/product/product_screen.dart';
import 'package:frontend_admin/screen/statistics/statistics_screen.dart';
import 'package:sidebarx/sidebarx.dart';

class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key, required this.controller});

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return HomeScreen();
          case 1:
            return const StatisticsScreen();
          case 2:
            return const ProductScreen();
          case 3:
            return const CategoryScreen();
          case 4:
            return const CustomerScreen();
          case 5:
            return const OrderScreen();
          default:
            return Text('Coming Soon', style: theme.textTheme.headlineSmall);
        }
      },
    );
  }
}
