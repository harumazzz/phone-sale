import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_admin/bloc/order/order_bloc.dart';
import 'package:frontend_admin/model/request/order_request.dart';
import 'package:frontend_admin/service/ui_helper.dart';
import 'package:intl/intl.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Order status mapping
  final Map<int, String> _statusTabs = {0: 'Chờ xử lý', 1: 'Đang chuẩn bị', 2: 'Đang giao', 3: 'Đã giao', 4: 'Đã hủy'};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderBloc>().add(const LoadOrderEvent());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      // Filter orders by selected tab status
      context.read<OrderBloc>().add(const LoadOrderEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        backgroundColor: theme.colorScheme.surface,
        bottom: TabBar(
          controller: _tabController,
          tabs: _statusTabs.values.map((status) => Tab(text: status)).toList(),
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          indicatorColor: theme.colorScheme.primary,
          dividerColor: Colors.transparent,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statusTabs.keys.map((status) => _buildOrderList(status)).toList(),
      ),
    );
  }

  Widget _buildOrderList(int status) {
    return BlocConsumer<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderError) {
          UIHelper.showErrorSnackbar(context: context, message: state.message);
        } else if (state is OrderUpdated) {
          UIHelper.showSuccessSnackbar(context: context, message: 'Cập nhật đơn hàng thành công');
          context.read<OrderBloc>().add(const LoadOrderEvent());
        }
      },
      builder: (context, state) {
        if (state is OrderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is OrderLoaded) {
          // Filter orders by current tab status
          final filteredOrders = state.orders.where((order) => order.status?.index == status).toList();

          if (filteredOrders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('Không có đơn hàng nào', style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<OrderBloc>().add(const LoadOrderEvent());
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildOrderStatistics(filteredOrders),
                  const SizedBox(height: 16),
                  _buildOrderDataTable(filteredOrders),
                ],
              ),
            ),
          );
        } else if (state is OrderError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(state.message, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<OrderBloc>().add(const LoadOrderEvent()),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildOrderStatistics(List<dynamic> orders) {
    final totalOrders = orders.length;
    final totalRevenue = orders.fold<double>(0, (sum, order) => sum + (order.totalPrice ?? 0));

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text('$totalOrders', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Tổng đơn hàng'),
                ],
              ),
            ),
            const VerticalDivider(),
            Expanded(
              child: Column(
                children: [
                  Text(
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(totalRevenue),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text('Tổng doanh thu'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDataTable(List<dynamic> orders) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Danh sách đơn hàng', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: DataTable2(
                columnSpacing: 12,
                horizontalMargin: 12,
                minWidth: 800,
                columns: const [
                  DataColumn2(label: Text('Mã đơn hàng'), size: ColumnSize.S),
                  DataColumn2(label: Text('Khách hàng'), size: ColumnSize.M),
                  DataColumn2(label: Text('Ngày đặt'), size: ColumnSize.S),
                  DataColumn2(label: Text('Tổng tiền'), size: ColumnSize.S),
                  DataColumn2(label: Text('Trạng thái'), size: ColumnSize.S),
                  DataColumn2(label: Text('Thao tác'), size: ColumnSize.M),
                ],
                rows: orders.map((order) => _buildOrderRow(order)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildOrderRow(dynamic order) {
    return DataRow(
      cells: [
        DataCell(Text('#${order.orderId}')),
        DataCell(Text(order.customerId?.toString() ?? 'N/A')),
        DataCell(Text(DateFormat('dd/MM/yyyy').format(order.orderDate))),
        DataCell(
          Text(NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(order.totalPrice ?? 0)),
        ),
        DataCell(_buildStatusChip(order.status?.index)),
        DataCell(_buildActionButtons(order)),
      ],
    );
  }

  Widget _buildStatusChip(int? status) {
    Color chipColor;
    String statusText;

    switch (status) {
      case 0:
        chipColor = Colors.orange;
        statusText = 'Chờ xử lý';
        break;
      case 1:
        chipColor = Colors.blue;
        statusText = 'Đang chuẩn bị';
        break;
      case 2:
        chipColor = Colors.purple;
        statusText = 'Đang giao';
        break;
      case 3:
        chipColor = Colors.green;
        statusText = 'Đã giao';
        break;
      case 4:
        chipColor = Colors.red;
        statusText = 'Đã hủy';
        break;
      default:
        chipColor = Colors.grey;
        statusText = 'Không xác định';
    }

    return Chip(
      label: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 12)),
      backgroundColor: chipColor,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildActionButtons(dynamic order) {
    final currentStatus = order.status?.index ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (currentStatus == 0) // Chờ xử lý
          IconButton(
            icon: const Icon(Icons.check_circle, color: Colors.green),
            tooltip: 'Duyệt đơn hàng',
            onPressed: () => _updateOrderStatus(order.orderId, 1),
          ),
        if (currentStatus == 1) // Đang chuẩn bị
          IconButton(
            icon: const Icon(Icons.local_shipping, color: Colors.blue),
            tooltip: 'Chuyển sang đang giao',
            onPressed: () => _updateOrderStatus(order.orderId, 2),
          ),
        if (currentStatus == 2) // Đang giao
          IconButton(
            icon: const Icon(Icons.done_all, color: Colors.green),
            tooltip: 'Đã giao hàng',
            onPressed: () => _updateOrderStatus(order.orderId, 3),
          ),
        if (currentStatus < 3) // Chưa hoàn thành
          IconButton(
            icon: const Icon(Icons.cancel, color: Colors.red),
            tooltip: 'Hủy đơn hàng',
            onPressed: () => _showCancelDialog(order.orderId),
          ),
        IconButton(
          icon: const Icon(Icons.visibility, color: Colors.blue),
          tooltip: 'Xem chi tiết',
          onPressed: () => _showOrderDetails(order),
        ),
      ],
    );
  }

  void _updateOrderStatus(int orderId, int newStatus) {
    context.read<OrderBloc>().add(
      UpdateOrderEvent(
        orderId: orderId,
        orderRequest: OrderRequest(
          totalPrice: 0, // This will be ignored by the backend
          customerId: '', // This will be ignored by the backend
          status: newStatus,
        ),
      ),
    );
  }

  void _showCancelDialog(int orderId) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận hủy đơn hàng'),
            content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _updateOrderStatus(orderId, 4);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Xác nhận hủy', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }

  void _showOrderDetails(dynamic order) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Chi tiết đơn hàng #${order.orderId}'),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Mã đơn hàng:', '#${order.orderId}'),
                  _buildDetailRow('Khách hàng:', order.customerId?.toString() ?? 'N/A'),
                  _buildDetailRow('Ngày đặt:', DateFormat('dd/MM/yyyy HH:mm').format(order.orderDate)),
                  _buildDetailRow(
                    'Tổng tiền:',
                    NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(order.totalPrice ?? 0),
                  ),
                  const SizedBox(height: 8),
                  const Text('Trạng thái:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  _buildStatusChip(order.status),
                ],
              ),
            ),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Đóng'))],
          ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
