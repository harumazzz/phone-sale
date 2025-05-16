import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/order_bloc/order_bloc.dart';
import '../order/order_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 24),
              _buildProfileSection(context),
              const SizedBox(height: 24),
              _buildMenuSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 6)],
      ),
      child: Row(
        children: [
          Text('Tài khoản của tôi', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const Spacer(),
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
    );
  }

  Widget _buildProfileSection(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLogin) {
          final user = state.data;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 6),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                  child: Text(
                    '${user.firstName?.isNotEmpty == true ? user.firstName![0] : ''}${user.lastName?.isNotEmpty == true ? user.lastName![0] : ''}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(user.email ?? 'Email không có sẵn', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 4),
                      Text(user.phoneNumber ?? 'Số điện thoại không có sẵn', style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          // Edit profile functionality
                        },
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Chỉnh sửa'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 6),
              ],
            ),
            child: Column(
              children: [
                const Icon(Icons.account_circle_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text('Chưa đăng nhập', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  'Vui lòng đăng nhập để sử dụng tính năng này',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    // Navigate to login screen
                    Navigator.pushNamed(context, '/login');
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Đăng nhập'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final theme = Theme.of(context);

    final menuItems = [
      {
        'icon': Icons.receipt_long_outlined,
        'title': 'Lịch sử đơn hàng',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create: (context) => OrderBloc(orderRepository: context.read<OrderBloc>().orderRepository),
                    child: const OrderHistoryScreen(),
                  ),
            ),
          );
        },
      },
      {
        'icon': Icons.favorite_border_outlined,
        'title': 'Danh sách yêu thích',
        'onTap': () {
          // Navigate to wishlist
        },
      },
      {
        'icon': Icons.location_on_outlined,
        'title': 'Địa chỉ giao hàng',
        'onTap': () {
          // Navigate to shipping addresses
        },
      },
      {
        'icon': Icons.payment_outlined,
        'title': 'Phương thức thanh toán',
        'onTap': () {
          // Navigate to payment methods
        },
      },
      {
        'icon': Icons.help_outline,
        'title': 'Trợ giúp & Hỗ trợ',
        'onTap': () {
          // Navigate to help & support
        },
      },
      {
        'icon': Icons.info_outline,
        'title': 'Giới thiệu',
        'onTap': () {
          // Navigate to about
        },
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 6)],
      ),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: menuItems.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return ListTile(
            leading: Icon(item['icon'] as IconData, color: theme.colorScheme.primary),
            title: Text(item['title'] as String),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: item['onTap'] as VoidCallback,
          );
        },
      ),
    );
  }
}
