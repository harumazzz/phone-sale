import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/order_bloc/order_bloc.dart';
import '../../model/response/order_response.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderBloc>().add(
        LoadOrderEvent(customerId: (context.read<AuthBloc>().state as AuthLogin).data.customerId!),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.receipt_outlined, color: theme.colorScheme.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Đơn hàng của tôi',
                          style: theme.textTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Quản lý và theo dõi đơn hàng của bạn tại đây',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                  ],
                ),
              ),
            ),

            // Order List
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading) {
                    return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                  }

                  if (state is OrderError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              'Lỗi: ${state.message}',
                              style: theme.textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is OrderLoaded) {
                    if (state.orders.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 24),
                              Text(
                                'Bạn chưa có đơn hàng nào',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Hãy mua sắm ngay để có được những sản phẩm tuyệt vời!',
                                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton.icon(
                                onPressed: () {
                                  // Navigate to home screen
                                },
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: const Text('Mua sắm ngay'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final order = state.orders[index];
                        return _buildOrderCard(context, order);
                      }, childCount: state.orders.length),
                    );
                  }

                  return const SliverFillRemaining(child: SizedBox.shrink());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderResponse order) {
    final theme = Theme.of(context);
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    final status = _getOrderStatus(order);
    final statusColor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order header with status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt, size: 18, color: theme.colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Đơn hàng #${order.orderId}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
          ),

          // Order details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailItem(
                      context,
                      Icons.calendar_today,
                      'Ngày đặt hàng',
                      order.orderDate != null ? DateFormat('dd/MM/yyyy').format(order.orderDate!) : '-',
                    ),
                    _buildDetailItem(
                      context,
                      Icons.shopping_bag_outlined,
                      'Số lượng',
                      '${2} sản phẩm', // Thay bằng số lượng thật khi API trả về
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tổng thanh toán', style: theme.textTheme.titleMedium),
                    Text(
                      formatter.format(order.totalPrice ?? 0),
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: theme.colorScheme.primary),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Đánh giá'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Xem chi tiết'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String title, String value) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(title, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }

  String _getOrderStatus(OrderResponse order) {
    // For now, return dummy status based on orderId
    if ((order.orderId ?? 0) % 3 == 0) {
      return 'Đang vận chuyển';
    }
    if ((order.orderId ?? 0) % 3 == 1) {
      return 'Hoàn thành';
    }
    return 'Đã hủy';
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Hoàn thành':
        return Colors.green;
      case 'Đang vận chuyển':
        return Colors.orange;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
