import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/order_bloc/order_bloc.dart';
import '../../model/response/order_response.dart';
import '../../model/response/order_with_items.dart';
import 'package:intl/intl.dart';
import 'order_detail_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderStatus? _selectedStatus;

  List<OrderWithItems> _filterOrders(List<OrderWithItems> orders) {
    if (_selectedStatus == null) {
      return orders;
    }
    return orders.where((orderWithItems) => orderWithItems.order.status == _selectedStatus).toList();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthLogin && authState.data.customerId != null) {
        context.read<OrderBloc>().add(OrderFetchWithItemsByCustomerIdEvent(customerId: authState.data.customerId!));
      }
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
                    const SizedBox(height: 16),
                    _buildStatusFilter(context),
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
                  if (state is OrderWithItemsLoaded) {
                    final filteredOrders = _filterOrders(state.ordersWithItems);

                    if (filteredOrders.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.receipt_long, size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 24),
                              Text(
                                _selectedStatus != null
                                    ? 'Không có đơn hàng nào với trạng thái này'
                                    : 'Bạn chưa có đơn hàng nào',
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
                        final orderWithItems = filteredOrders[index];
                        return _buildOrderWithItemsCard(context, orderWithItems);
                      }, childCount: filteredOrders.length),
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
                      'Đang tải...', // Fallback for old OrderResponse without items
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
                      order.formattedTotalPriceVnd,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
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
          ),
        ],
      ),
    );
  }

  Widget _buildOrderWithItemsCard(BuildContext context, OrderWithItems orderWithItems) {
    final theme = Theme.of(context);
    final order = orderWithItems.order;
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

          // Product images section
          if (orderWithItems.orderItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sản phẩm đã đặt', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: orderWithItems.orderItems.length,
                      itemBuilder: (context, index) {
                        final itemWithProduct = orderWithItems.orderItems[index];
                        final product = itemWithProduct.product;
                        final orderItem = itemWithProduct.orderItem;
                        return Container(
                          margin: const EdgeInsets.only(right: 12),
                          child: Stack(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      product.productLink != null && product.productLink!.isNotEmpty
                                          ? Image.network(
                                            product.productLink!,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[100],
                                                child: Icon(Icons.phone_android, color: Colors.grey[400], size: 32),
                                              );
                                            },
                                          )
                                          : Container(
                                            color: Colors.grey[100],
                                            child: Icon(Icons.phone_android, color: Colors.grey[400], size: 32),
                                          ),
                                ),
                              ),
                              if (orderItem.quantity != null && orderItem.quantity! > 1)
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                    child: Text(
                                      '${orderItem.quantity}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
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
                      '${orderWithItems.totalItems} sản phẩm',
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
                      order.formattedTotalPriceVnd,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
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

  Widget _buildStatusFilter(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
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
    final theme = Theme.of(context);
    final isSelected = _selectedStatus == status;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedStatus = selected ? status : null;
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
      checkmarkColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? theme.colorScheme.primary : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  String _getOrderStatus(OrderResponse order) {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Đang xử lý';
      case OrderStatus.processing:
        return 'Đang chuẩn bị';
      case OrderStatus.shipped:
        return 'Đang giao';
      case OrderStatus.delivered:
        return 'Đã giao';
      case OrderStatus.cancelled:
        return 'Đã hủy';
      default:
        return 'Đang xử lý';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Đã giao':
        return Colors.green;
      case 'Đang giao':
        return Colors.purple;
      case 'Đang chuẩn bị':
        return Colors.orange;
      case 'Đang xử lý':
        return Colors.blue;
      case 'Đã hủy':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
