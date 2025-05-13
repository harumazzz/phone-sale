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
    return Scaffold(
      appBar: AppBar(title: const Text('Đơn hàng của tôi'), centerTitle: true, backgroundColor: Colors.deepPurple),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderError) {
            return Center(child: Text('Lỗi: ${state.message}'));
          }
          if (state is OrderLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('Bạn chưa có đơn hàng nào.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _orderCard(order);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _orderCard(OrderResponse order) {
    final status = _getOrderStatus(order);
    final statusColor = _getStatusColor(status);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('#${order.orderId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Chip(label: Text(status, style: const TextStyle(color: Colors.white)), backgroundColor: statusColor),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Ngày đặt: ${order.orderDate != null ? DateFormat('dd/MM/yyyy').format(order.orderDate!) : '-'}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 4),
            Text('Tổng tiền: ${order.totalPrice ?? 0} đ', style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: const Text('Xem chi tiết')),
            ),
          ],
        ),
      ),
    );
  }

  String _getOrderStatus(OrderResponse order) {
    // TODO: Replace with real status from order/shipment/payment if available
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
