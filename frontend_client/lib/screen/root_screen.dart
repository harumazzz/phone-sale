import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'home_screen/home_screen.dart';
import 'search/search_screen.dart';
import 'settings/setting_screen.dart';
import 'order/order_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<RootScreen> createState() => _RootScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('initialIndex', initialIndex));
  }
}

class _RootScreenState extends State<RootScreen> {
  late int _selectedIndex;

  static const _screens = <Widget>[HomeScreen(), SearchScreen(), OrderScreen(), SettingScreen()];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: NavigationBar(
            height: 70,
            elevation: 0,
            backgroundColor: Colors.white,
            selectedIndex: _selectedIndex,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.1),
            destinations: <Widget>[
              NavigationDestination(
                icon: Icon(Symbols.home, color: Colors.grey[600]),
                selectedIcon: Icon(Symbols.home, fill: 1, color: theme.colorScheme.primary),
                label: 'Trang chủ',
              ),
              NavigationDestination(
                icon: Icon(Symbols.search, color: Colors.grey[600]),
                selectedIcon: Icon(Symbols.search, fill: 1, color: theme.colorScheme.primary),
                label: 'Tìm kiếm',
              ),
              NavigationDestination(
                icon: Icon(Symbols.receipt_long, color: Colors.grey[600]),
                selectedIcon: Icon(Symbols.receipt_long, fill: 1, color: theme.colorScheme.primary),
                label: 'Đơn hàng',
              ),
              NavigationDestination(
                icon: Icon(Symbols.settings, color: Colors.grey[600]),
                selectedIcon: Icon(Symbols.settings, fill: 1, color: theme.colorScheme.primary),
                label: 'Cài đặt',
              ),
            ],
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
