import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/order_bloc/order_bloc.dart';
import '../../model/response/order_response.dart';
import 'order_detail_screen.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  OrderStatus? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthLogin && authState.data.customerId != null) {
      context.read<OrderBloc>().add(OrderFetchByCustomerIdEvent(customerId: authState.data.customerId!));
    }
  }

  Widget _buildStatusFilter(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(context, null, 'Tất cả'),
          const SizedBox(width: 8),
          _buildFilterChip(context, OrderStatus.pending, 'Đang xử lý'),
          const SizedBox(width: 8),
          _buildFilterChip(context, OrderStatus.processing, 'Đang chuẩn bị'),
          const SizedBox(width: 8),
          _buildFilterChip(context, OrderStatus.shipped, 'Đang giao'),
          const SizedBox(width: 8),
          _buildFilterChip(context, OrderStatus.delivered, 'Đã giao'),
          const SizedBox(width: 8),
          _buildFilterChip(context, OrderStatus.cancelled, 'Đã hủy'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, OrderStatus? status, String label) {
    final isSelected = _selectedFilter == status;

    Color chipColor;
    IconData iconData;

    switch (status) {
      case OrderStatus.pending:
        chipColor = Colors.blue;
        iconData = Icons.hourglass_empty;
        break;
      case OrderStatus.processing:
        chipColor = Colors.orange;
        iconData = Icons.inventory;
        break;
      case OrderStatus.shipped:
        chipColor = Colors.purple;
        iconData = Icons.local_shipping;
        break;
      case OrderStatus.delivered:
        chipColor = Colors.green;
        iconData = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        chipColor = Colors.red;
        iconData = Icons.cancel;
        break;
      default:
        chipColor = Colors.grey;
        iconData = Icons.list;
    }

    return FilterChip(
      selected: isSelected,
      label: Text(label),
      avatar: Icon(iconData, size: 16, color: isSelected ? Colors.white : chipColor),
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : null,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      backgroundColor: chipColor.withValues(alpha: 0.1),
      selectedColor: chipColor,
      side: BorderSide(color: chipColor.withValues(alpha: 0.3)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? status : null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi_VN', decimalDigits: 0);
    final formatDate = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Lịch sử đơn hàng', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadOrders(),
        child: Column(
          children: [
            _buildStatusFilter(context),
            Expanded(
              child: BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrderLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is OrderLoaded) {
                    final orders = state.orders;

                    // Apply filter if selected
                    final filteredOrders =
                        _selectedFilter != null
                            ? orders.where((order) => order.status == _selectedFilter).toList()
                            : orders;

                    if (filteredOrders.isEmpty) {
                      return _buildEmptyState(context);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        return _buildOrderCard(context, order, formatCurrency, formatDate);
                      },
                    );
                  } else if (state is OrderError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[300], size: 64),
                          const SizedBox(height: 16),
                          Text('Lỗi: ${state.message}', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 16),
                          ElevatedButton(onPressed: _loadOrders, child: const Text('Thử lại')),
                        ],
                      ),
                    );
                  }
                  return const Center(child: Text('Không có dữ liệu'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long_outlined, size: 80, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 24),
          Text(
            _selectedFilter == null ? 'Chưa có đơn hàng nào' : 'Không tìm thấy đơn hàng',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            _selectedFilter == null
                ? 'Đơn hàng của bạn sẽ xuất hiện ở đây'
                : 'Không có đơn hàng nào thuộc trạng thái này',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          if (_selectedFilter != null)
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedFilter = null;
                });
              },
              icon: const Icon(Icons.filter_list_off),
              label: const Text('Xóa bộ lọc'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Tiếp tục mua sắm'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    OrderResponse order,
    NumberFormat currencyFormatter,
    DateFormat dateFormatter,
  ) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => BlocProvider(
                    create: (context) => OrderBloc(orderRepository: context.read<OrderBloc>().orderRepository),
                    child: OrderDetailScreen(orderId: order.orderId!),
                  ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đơn hàng #${order.orderId}',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  _buildStatusChip(context, order.status),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.date_range_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text('Ngày đặt: ${dateFormatter.format(order.orderDate!)}', style: theme.textTheme.bodyMedium),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.monetization_on_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Tổng tiền: ${currencyFormatter.format(order.totalPrice)}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider(
                                create:
                                    (context) => OrderBloc(orderRepository: context.read<OrderBloc>().orderRepository),
                                child: OrderDetailScreen(orderId: order.orderId!),
                              ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Xem chi tiết'),
                  ),
                  if (order.status == OrderStatus.pending)
                    ElevatedButton(
                      onPressed: () {
                        _showCancelOrderDialog(context, order.orderId!);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Hủy đơn'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, OrderStatus? status) {
    Color chipColor;
    String statusText;
    IconData iconData;

    switch (status) {
      case OrderStatus.pending:
        chipColor = Colors.blue;
        statusText = 'Đang xử lý';
        iconData = Icons.hourglass_empty;
        break;
      case OrderStatus.processing:
        chipColor = Colors.orange;
        statusText = 'Đang chuẩn bị';
        iconData = Icons.inventory;
        break;
      case OrderStatus.shipped:
        chipColor = Colors.purple;
        statusText = 'Đang giao';
        iconData = Icons.local_shipping;
        break;
      case OrderStatus.delivered:
        chipColor = Colors.green;
        statusText = 'Đã giao';
        iconData = Icons.check_circle;
        break;
      case OrderStatus.cancelled:
        chipColor = Colors.red;
        statusText = 'Đã hủy';
        iconData = Icons.cancel;
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Không xác định';
        iconData = Icons.help_outline;
    }

    return Chip(
      padding: EdgeInsets.zero,
      backgroundColor: chipColor.withValues(alpha: 0.1),
      avatar: Icon(iconData, size: 16, color: chipColor),
      label: Text(statusText, style: TextStyle(color: chipColor, fontWeight: FontWeight.bold, fontSize: 12)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: chipColor.withValues(alpha: 0.3)),
      ),
    );
  }

  void _showCancelOrderDialog(BuildContext context, int orderId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Hủy đơn hàng'),
            content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Không')),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // Cancel the order by changing the status to cancelled
                  context.read<OrderBloc>().add(
                    OrderUpdateStatusEvent(orderId: orderId, status: OrderStatus.cancelled.index),
                  );
                  Navigator.pop(context);

                  // Reload orders to show updated status
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã hủy đơn hàng')));

                  // Delayed reload to allow the status update to take effect
                  Future.delayed(const Duration(milliseconds: 300), _loadOrders);
                },
                child: const Text('Hủy đơn hàng'),
              ),
            ],
          ),
    );
  }
}
