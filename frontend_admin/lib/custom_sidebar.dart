import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sidebarx/sidebarx.dart';

import 'constant/color_constant.dart';

class CustomSidebar extends StatelessWidget {
  const CustomSidebar({super.key, required SidebarXController controller}) : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1)],
        ),
        hoverColor: Colors.grey[100],
        textStyle: TextStyle(color: Colors.black.withValues(alpha: 0.8), fontWeight: FontWeight.w500),
        selectedTextStyle: TextStyle(color: ColorConstant.primaryColor, fontWeight: FontWeight.bold),
        hoverTextStyle: TextStyle(color: Colors.black.withValues(alpha: 0.9), fontWeight: FontWeight.w600),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white)),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue.withValues(alpha: 0.1),
          boxShadow: [BoxShadow(color: ColorConstant.primaryColor.withValues(alpha: 0.05), blurRadius: 5)],
        ),
        iconTheme: IconThemeData(color: Colors.grey[800], size: 22),
        selectedIconTheme: IconThemeData(color: ColorConstant.primaryColor, size: 22),
      ),
      extendedTheme: SidebarXTheme(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, spreadRadius: 1)],
        ),
      ),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Symbols.smartphone, color: ColorConstant.primaryColor, size: 32),
                  if (extended) const SizedBox(width: 12),
                  if (extended)
                    Text(
                      'PhoneSale',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.primaryColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      items: [
        SidebarXItem(
          icon: Symbols.dashboard_rounded,
          label: 'Trang chủ',
          iconBuilder: (selected, hovered) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Symbols.dashboard_rounded, color: ColorConstant.primaryColor, size: 20),
            );
          },
        ),
        SidebarXItem(
          icon: Symbols.analytics,
          label: 'Thống kê',
          iconBuilder: (selected, hovered) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.purple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Symbols.analytics, color: const Color(0xFF9C27B0), size: 20),
            );
          },
        ),
        SidebarXItem(
          icon: Symbols.shopping_bag,
          label: 'Sản phẩm',
          iconBuilder: (selected, hovered) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Symbols.shopping_bag, color: Colors.orange, size: 20),
            );
          },
        ),
        SidebarXItem(
          icon: Symbols.category,
          label: 'Danh mục',
          iconBuilder: (selected, hovered) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Symbols.category, color: Colors.green, size: 20),
            );
          },
        ),
        SidebarXItem(
          icon: Symbols.people,
          label: 'Người dùng',
          iconBuilder: (selected, hovered) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.indigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Symbols.people, color: Colors.indigo, size: 20),
            );
          },
        ),
        SidebarXItem(
          icon: Symbols.receipt_long,
          label: 'Đơn hàng',
          iconBuilder: (selected, hovered) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Symbols.receipt_long, color: Colors.red, size: 20),
            );
          },
        ),
        SidebarXItem(
          icon: Symbols.local_offer,
          label: 'Mã giảm giá',
          iconBuilder: (selected, hovered) {
            return Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.teal.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Symbols.local_offer, color: Colors.teal, size: 20),
            );
          },
        ),
      ],
    );
  }
}
