import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'home_screen/home_screen.dart';
import 'search/search_screen.dart';
import 'settings/setting_screen.dart';
import 'order/order_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;

  static const _screens = <Widget>[HomeScreen(), SearchScreen(), OrderScreen(), SettingScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        destinations: const <Widget>[
          NavigationDestination(icon: Icon(Symbols.home), selectedIcon: Icon(Symbols.home_filled), label: 'Trang chủ'),
          NavigationDestination(
            icon: Icon(Symbols.search),
            selectedIcon: Icon(Symbols.search_activity),
            label: 'Tìm kiếm',
          ),
          NavigationDestination(
            icon: Icon(Symbols.receipt_long),
            selectedIcon: Icon(Symbols.receipt_long),
            label: 'Đơn hàng',
          ),
          NavigationDestination(
            icon: Icon(Symbols.settings),
            selectedIcon: Icon(Symbols.settings_sharp),
            label: 'Cài đặt',
          ),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
