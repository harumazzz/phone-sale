import 'package:flutter/material.dart';
import 'package:frontend_admin/screen/category/category_screen.dart';
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
            return ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemBuilder:
                  (context, index) => Container(
                    height: 100,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: 10,
                      right: 10,
                      left: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).canvasColor,
                      boxShadow: const [BoxShadow()],
                    ),
                  ),
            );
          case 3:
            return const CategoryScreen();
          default:
            return Text('null', style: theme.textTheme.headlineSmall);
        }
      },
    );
  }
}
