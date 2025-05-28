import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../widget/custom_appbar/custom_appbar.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  int _touchedIndex = -1;

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
    final List<Map<String, dynamic>> chartData = [
      {'label': 'Điện thoại', 'value': 40.0, 'count': 12},
      {'label': 'Máy tính bảng', 'value': 30.0, 'count': 8},
      {'label': 'Phụ kiện', 'value': 15.0, 'count': 6},
      {'label': 'Khác', 'value': 15.0, 'count': 4},
    ];

    final List<PieChartSectionData> sections =
        chartData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final isTouched = index == _touchedIndex;
          final fontSize = isTouched ? 16.0 : 14.0;
          final radius = isTouched ? 70.0 : 60.0;
          final shadows = isTouched ? [const Shadow(blurRadius: 2)] : <Shadow>[];

          Color sectionColor;
          Color textColor;

          switch (index) {
            case 0:
              sectionColor = Theme.of(context).colorScheme.primaryContainer;
              textColor = Theme.of(context).colorScheme.onPrimaryContainer;
              break;
            case 1:
              sectionColor = Theme.of(context).colorScheme.secondaryContainer;
              textColor = Theme.of(context).colorScheme.onSecondaryContainer;
              break;
            case 2:
              sectionColor = Theme.of(context).colorScheme.tertiaryContainer;
              textColor = Theme.of(context).colorScheme.onTertiaryContainer;
              break;
            case 3:
              sectionColor = Theme.of(context).colorScheme.errorContainer;
              textColor = Theme.of(context).colorScheme.onErrorContainer;
              break;
            default:
              sectionColor = Colors.grey;
              textColor = Colors.black;
          }

          return PieChartSectionData(
            color: sectionColor,
            value: data['value'],
            title: isTouched ? '${data['label']}\n${data['count']} sản phẩm' : '${data['value']}%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: textColor, shadows: shadows),
          );
        }).toList();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thống kê sản phẩm đã mua',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children:
                  chartData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final data = entry.value;
                    Color legendColor;

                    switch (index) {
                      case 0:
                        legendColor = Theme.of(context).colorScheme.primaryContainer;
                        break;
                      case 1:
                        legendColor = Theme.of(context).colorScheme.secondaryContainer;
                        break;
                      case 2:
                        legendColor = Theme.of(context).colorScheme.tertiaryContainer;
                        break;
                      case 3:
                        legendColor = Theme.of(context).colorScheme.errorContainer;
                        break;
                      default:
                        legendColor = Colors.grey;
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(color: legendColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 8),
                        Text('${data['label']} (${data['count']})', style: const TextStyle(fontSize: 12)),
                      ],
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: PieChart(
                PieChartData(
                  sections: sections,
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 2,
                  centerSpaceRadius: 50,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          _touchedIndex = -1;
                          return;
                        }
                        _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                    enabled: true,
                  ),
                ),
              ),
            ),
            if (_touchedIndex >= 0 && _touchedIndex < chartData.length)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Bạn đã mua ${chartData[_touchedIndex]['count']} sản phẩm ${chartData[_touchedIndex]['label'].toLowerCase()}, '
                        'chiếm ${chartData[_touchedIndex]['value']}% tổng số sản phẩm đã mua.',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
