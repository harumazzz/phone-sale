import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sidebarx/sidebarx.dart';

import 'constant/color_constant.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key, required SidebarXController controller})
    : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: ColorConstant.canvasColor,
          borderRadius: BorderRadius.circular(20),
        ),
        hoverColor: ColorConstant.scaffoldBackgroundColor,
        textStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        hoverTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ColorConstant.canvasColor),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: ColorConstant.actionColor.withValues(alpha: 0.37),
          ),
          gradient: const LinearGradient(
            colors: [
              ColorConstant.accentCanvasColor,
              ColorConstant.canvasColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.28),
              blurRadius: 30,
            ),
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withValues(alpha: 0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(color: Colors.white, size: 20),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(color: ColorConstant.canvasColor),
      ),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(Symbols.shopping_bag, color: Colors.white, size: 40),
          ),
        );
      },
      items: [
        const SidebarXItem(icon: Symbols.home, label: 'Trang chủ'),
        const SidebarXItem(icon: Symbols.analytics, label: 'Thống kê'),
        const SidebarXItem(icon: Symbols.package_2, label: 'Sản phẩm'),
        const SidebarXItem(icon: Symbols.category, label: 'Danh mục'),
        const SidebarXItem(icon: Symbols.people, label: 'Người dùng'),
        const SidebarXItem(icon: Symbols.orders, label: 'Hóa đơn'),
      ],
    );
  }
}
