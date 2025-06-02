import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/order_bloc/order_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../model/response/order_response.dart';
import '../../model/response/order_item_with_product.dart';
import '../../utils/currency_utils.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});
  final int orderId;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('orderId', orderId));
  }
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  void _loadOrderDetails() {
    context.read<OrderBloc>().add(OrderFetchWithItemsEvent(id: widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatDate = DateFormat('dd/MM/yyyy HH:mm');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Chi tiết đơn hàng', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          debugPrint('Order detail screen state: ${state.runtimeType}');
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrderDetailLoaded) {
            final order = state.order;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderStatusCard(context, order),
                  const SizedBox(height: 16),
                  _buildOrderInfoCard(context, order, formatDate),
                  const SizedBox(height: 16),
                  _buildShippingInfoCard(context),
                  const SizedBox(height: 16),
                  _buildOrderItemsCard(context, null), // No items for basic order
                  const SizedBox(height: 24),
                  if (order.status == OrderStatus.pending)
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showCancelOrderDialog(context, order.orderId!);
                          },
                          icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                          label: const Text('HỦY ĐƠN HÀNG', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          } else if (state is OrderDetailWithItemsLoaded) {
            final orderWithItems = state.orderWithItems;
            final order = orderWithItems.order;
            debugPrint('OrderDetailWithItemsLoaded - Order items count: ${orderWithItems.orderItems.length}');
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderStatusCard(context, order),
                  const SizedBox(height: 16),
                  _buildOrderInfoCard(context, order, formatDate),
                  const SizedBox(height: 16),
                  _buildShippingInfoCard(context),
                  const SizedBox(height: 16),
                  _buildOrderItemsCard(context, orderWithItems.orderItems),
                  const SizedBox(height: 24),
                  if (order.status == OrderStatus.pending)
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showCancelOrderDialog(context, order.orderId!);
                          },
                          icon: const Icon(Icons.cancel_outlined, color: Colors.white),
                          label: const Text('HỦY ĐƠN HÀNG', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
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
                  ElevatedButton(onPressed: _loadOrderDetails, child: const Text('Thử lại')),
                ],
              ),
            );
          }
          return const Center(child: Text('Không tìm thấy thông tin đơn hàng'));
        },
      ),
    );
  }

  Widget _buildOrderStatusCard(BuildContext context, OrderResponse order) {
    final theme = Theme.of(context);

    // Define status information
    Map<OrderStatus, Map<String, dynamic>> statusInfo = {
      OrderStatus.pending: {
        'title': 'Đơn hàng đang chờ xử lý',
        'color': Colors.blue,
        'icon': Icons.hourglass_empty,
        'description': 'Đơn hàng của bạn đã được đặt thành công và đang chờ được xác nhận.',
      },
      OrderStatus.processing: {
        'title': 'Đơn hàng đang được xử lý',
        'color': Colors.orange,
        'icon': Icons.inventory_2_outlined,
        'description': 'Đơn hàng của bạn đã được xác nhận và đang được chuẩn bị.',
      },
      OrderStatus.shipped: {
        'title': 'Đơn hàng đang được giao',
        'color': Colors.purple,
        'icon': Icons.local_shipping_outlined,
        'description': 'Đơn hàng của bạn đang được vận chuyển đến địa chỉ giao hàng.',
      },
      OrderStatus.delivered: {
        'title': 'Đơn hàng đã giao thành công',
        'color': Colors.green,
        'icon': Icons.check_circle_outline,
        'description': 'Đơn hàng của bạn đã được giao thành công. Cảm ơn bạn đã mua sắm!',
      },
      OrderStatus.cancelled: {
        'title': 'Đơn hàng đã bị hủy',
        'color': Colors.red,
        'icon': Icons.cancel_outlined,
        'description': 'Đơn hàng này đã bị hủy.',
      },
    };

    // Get status info or use default
    final info =
        statusInfo[order.status] ??
        {
          'title': 'Trạng thái không xác định',
          'color': Colors.grey,
          'icon': Icons.help_outline,
          'description': 'Không thể xác định trạng thái đơn hàng.',
        };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(info['icon'], color: info['color'], size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    info['title'],
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: info['color']),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(info['description'], style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 16),
            _buildOrderStatusStepper(context, order.status ?? OrderStatus.pending),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusStepper(BuildContext context, OrderStatus currentStatus) {
    final steps = [
      {'status': OrderStatus.pending, 'label': 'Đặt hàng'},
      {'status': OrderStatus.processing, 'label': 'Xác nhận'},
      {'status': OrderStatus.shipped, 'label': 'Vận chuyển'},
      {'status': OrderStatus.delivered, 'label': 'Đã giao'},
    ];

    bool isCancelled = currentStatus == OrderStatus.cancelled;

    return SizedBox(
      height: 70,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isEven) {
            // This is a step dot
            int stepIdx = index ~/ 2;
            OrderStatus stepStatus = steps[stepIdx]['status'] as OrderStatus;
            String label = steps[stepIdx]['label'] as String;

            bool isActive = currentStatus.index >= stepStatus.index;
            if (isCancelled) {
              isActive = false;
            }

            return Expanded(
              child: Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                      border: isActive ? null : Border.all(color: Colors.grey[400]!),
                    ),
                    child: isActive ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.black87 : Colors.grey[500],
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            // This is a connector line
            int prevStepIdx = index ~/ 2;
            bool isActive = currentStatus.index > prevStepIdx;
            if (isCancelled) {
              isActive = false;
            }

            return Expanded(
              child: Container(height: 3, color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey[300]),
            );
          }
        }),
      ),
    );
  }

  Widget _buildOrderInfoCard(BuildContext context, OrderResponse order, DateFormat dateFormatter) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin đơn hàng', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildInfoRow('Mã đơn hàng:', '#${order.orderId}'),
            const SizedBox(height: 8),
            _buildInfoRow('Ngày đặt:', dateFormatter.format(order.orderDate!)),
            const SizedBox(height: 8),
            _buildInfoRow('Tổng tiền:', order.formattedTotalPriceVnd),
            const SizedBox(height: 8),
            _buildInfoRow('Phương thức thanh toán:', 'Thanh toán khi nhận hàng (COD)'),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingInfoCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Thông tin giao hàng', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthLogin) {
                  final customer = authState.data;
                  return Column(
                    children: [
                      _buildInfoRow('Người nhận:', customer.name.isNotEmpty ? customer.name : 'Chưa cập nhật'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Số điện thoại:', customer.phoneNumber ?? 'Chưa cập nhật'),
                      const SizedBox(height: 8),
                      _buildInfoRow('Địa chỉ:', customer.address ?? 'Chưa cập nhật'),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildInfoRow('Người nhận:', 'Chưa đăng nhập'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Số điện thoại:', 'Chưa đăng nhập'),
                    const SizedBox(height: 8),
                    _buildInfoRow('Địa chỉ:', 'Chưa đăng nhập'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemsCard(BuildContext context, List<OrderItemWithProduct>? orderItems) {
    final theme = Theme.of(context);

    // Use real data if available, otherwise show empty state
    final items = orderItems ?? [];

    // Debug logging
    if (kDebugMode) {
      print('DEBUG: OrderItems count: ${items.length}');
      if (items.isNotEmpty) {
        for (int i = 0; i < items.length; i++) {
          print(
            'DEBUG: Item $i: ${items[i].product.model} - ${items[i].orderItem.quantity} x ${items[i].orderItem.price}',
          );
        }
      }
    }

    if (items.isEmpty) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Sản phẩm đã mua', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 8),
                    Text('Không có sản phẩm nào', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } // Calculate totals from real data
    double subtotal = items.fold(0.0, (sum, item) {
      double price = item.orderItem.price?.toDouble() ?? 0.0;
      int quantity = item.orderItem.quantity ?? 0;
      return sum + (price * quantity);
    });

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sản phẩm đã mua', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        image:
                            item.product.productLink != null && item.product.productLink!.isNotEmpty
                                ? DecorationImage(image: NetworkImage(item.product.productLink!), fit: BoxFit.cover)
                                : null,
                      ),
                      child:
                          item.product.productLink == null || item.product.productLink!.isEmpty
                              ? Center(child: Icon(Icons.phone_iphone, color: Colors.grey[400]))
                              : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.model ?? 'Sản phẩm không xác định',
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('SL: ${item.orderItem.quantity ?? 0}', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    Text(item.orderItem.formattedPriceVnd, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tạm tính:', style: theme.textTheme.bodyLarge),
                Text(CurrencyUtils.formatVnd(CurrencyUtils.usdToVnd(subtotal) ?? 0), style: theme.textTheme.bodyLarge),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Phí vận chuyển:', style: theme.textTheme.bodyLarge),
                Text('Miễn phí', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tổng cộng:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(
                  CurrencyUtils.formatVnd(subtotal),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 150, child: Text(label, style: const TextStyle(color: Colors.grey))),
        Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500))),
      ],
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
                  // Cancel the order
                  context.read<OrderBloc>().add(
                    OrderUpdateStatusEvent(orderId: orderId, status: OrderStatus.cancelled.index),
                  );
                  Navigator.pop(context);

                  // Reload order details to show updated status
                  _loadOrderDetails();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã hủy đơn hàng thành công'), behavior: SnackBarBehavior.floating),
                  );
                },
                child: const Text('Hủy đơn hàng'),
              ),
            ],
          ),
    );
  }
}
