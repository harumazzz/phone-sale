import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../widget/custom_appbar/custom_appbar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const CustomAppbar(title: Text('Cài đặt')),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildUserInfo(context),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider()),
            _buildPurchasedProductsStoreChart(context),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0), child: Divider()),
            _buildSettingsSection(context),
          ]),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Thông tin người dùng'),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLogin) {
                return Row(
                  spacing: 20.0,
                  children: [
                    const CircleAvatar(radius: 30, child: Icon(Symbols.person_outline)),
                    _buildUserDetails(state),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserDetails(AuthLogin state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(state.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        Text('Email: ${state.email}', style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSettingItem(
            icon: Symbols.notifications,
            title: 'Thông báo',
            onTap: () {
              _showDummyDialog(context, 'Thông báo', 'Đây là nơi hiển thị các thông báo của bạn.');
            },
          ),
          _buildSettingItem(
            icon: Symbols.language,
            title: 'Ngôn ngữ',
            onTap: () {
              _showDummyDialog(context, 'Ngôn ngữ', 'Chọn ngôn ngữ ưa thích của bạn: Tiếng Việt, English.');
            },
          ),
          _buildSettingItem(
            icon: Symbols.lock,
            title: 'Bảo mật',
            onTap: () {
              _showDummyDialog(context, 'Bảo mật', 'Cài đặt bảo mật tài khoản: Đổi mật khẩu, Xác minh 2 bước.');
            },
          ),
          _buildSettingItem(
            icon: Symbols.help,
            title: 'Trợ giúp',
            onTap: () {
              _showDummyDialog(context, 'Trợ giúp', 'Liên hệ hỗ trợ hoặc xem các câu hỏi thường gặp.');
            },
          ),
          const Divider(),
          _buildEmailNotificationSwitch(),
          const Divider(),
          _buildLogoutItem(),
        ],
      ),
    );
  }

  Widget _buildEmailNotificationSwitch() {
    return SwitchListTile(
      value: true,
      onChanged: (bool value) {},
      title: const Text('Nhận thông báo qua email'),
      subtitle: const Text('Nhận email khuyến mãi và thông tin sản phẩm mới'),
    );
  }

  Widget _buildLogoutItem() {
    return ListTile(leading: const Icon(Icons.exit_to_app), title: const Text('Đăng xuất'), onTap: () {});
  }

  Widget _buildSettingItem({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  void _showDummyDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildPurchasedProductsStoreChart(BuildContext context) {
    final List<PieChartSectionData> sections = [
      PieChartSectionData(
        color: Theme.of(context).colorScheme.primaryContainer,
        value: 40,
        title: 'Điện thoại',
        radius: 60, // Increased radius
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      PieChartSectionData(
        color: Theme.of(context).colorScheme.secondaryContainer,
        value: 30,
        title: 'Máy tính bảng',
        radius: 60, // Increased radius
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
      PieChartSectionData(
        color: Theme.of(context).colorScheme.tertiaryContainer,
        value: 15,
        title: 'Phụ kiện',
        radius: 60, // Increased radius
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onTertiaryContainer,
        ),
      ),
      PieChartSectionData(
        color: Theme.of(context).colorScheme.errorContainer, // Using error container for variety
        value: 15,
        title: 'Khác',
        radius: 60, // Increased radius
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
    ];

    return Card(
      // Wrap with a Card
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Changed to Text widget for consistency with _buildSectionTitle
              'Thống kê sản phẩm đã mua',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24), // Increased spacing
            SizedBox(
              height: 220, // Adjusted height
              child: PieChart(
                PieChartData(
                  sections: sections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2, // Added space between sections
                  centerSpaceRadius: 50, // Adjusted center space
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // TODO(self): Implement touch interaction if needed
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
