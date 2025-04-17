import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(),
            ),
            _buildSettingsSection(),
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
                    const CircleAvatar(
                      radius: 30,
                      child: Icon(Symbols.person_outline),
                    ),
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
        Text(
          state.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          'Email: ${state.email}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSettingItem(
            icon: Symbols.notifications,
            title: 'Thông báo',
            onTap: () {},
          ),
          _buildSettingItem(
            icon: Symbols.language,
            title: 'Ngôn ngữ',
            onTap: () {},
          ),
          _buildSettingItem(icon: Symbols.lock, title: 'Bảo mật', onTap: () {}),
          _buildSettingItem(
            icon: Symbols.help,
            title: 'Trợ giúp',
            onTap: () {},
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
    return ListTile(
      leading: const Icon(Icons.exit_to_app),
      title: const Text('Đăng xuất'),
      onTap: () {},
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
