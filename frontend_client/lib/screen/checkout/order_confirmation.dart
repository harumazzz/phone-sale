import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/order_bloc/order_bloc.dart';
import '../../model/request/order_request.dart';
import '../order/order_success_screen.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrderConfirmation extends StatefulWidget {
  const OrderConfirmation({super.key, required this.checkoutData, required this.onBack});
  final Map<String, dynamic> checkoutData;
  final void Function() onBack;

  @override
  State<OrderConfirmation> createState() => _OrderConfirmationState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, dynamic>>('checkoutData', checkoutData));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onBack', onBack));
  }
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  bool _isPlacingOrder = false;
  bool _orderPlaced = false;
  String? _errorMessage;
  int? _orderId;
  @override
  Widget build(BuildContext context) {
    if (_orderPlaced && _orderId != null) {
      // Navigate to the success screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: BlocProvider.of<OrderBloc>(context),
                  child: OrderSuccessScreen(orderId: _orderId!),
                ),
          ),
        );
      });
      return const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      return _buildOrderError(context);
    } else {
      return _buildOrderReview(context);
    }
  }

  Widget _buildOrderReview(BuildContext context) {
    final theme = Theme.of(context);
    final formatCurrency = NumberFormat.simpleCurrency(locale: 'vi_VN', decimalDigits: 0, name: '₫');
    final cartItems = widget.checkoutData['cartItems'] ?? [];
    final subtotal = widget.checkoutData['subtotal'] ?? 0.0;
    final discountAmount = widget.checkoutData['discountAmount'] ?? 0.0;
    final shippingFee = widget.checkoutData['deliveryOption'] == 'express' ? 30000.0 : 0.0;
    final total = subtotal - discountAmount + shippingFee;

    // Update the total in the checkout data
    if (widget.checkoutData['total'] != total) {
      widget.checkoutData['total'] = total;
      widget.checkoutData['shippingFee'] = shippingFee;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Xác nhận đơn hàng', Symbols.check_circle),
            const SizedBox(height: 16),

            // Cart Items
            if (cartItems.isNotEmpty) ...[
              _buildSummaryCard(
                context,
                'Sản phẩm đặt hàng',
                Column(
                  children: cartItems.map<Widget>((item) => _buildCartItem(context, item, formatCurrency)).toList(),
                ),
              ),
            ],

            // Order Summary
            _buildSummaryCard(
              context,
              'Chi tiết đơn hàng',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryRow('Tạm tính', formatCurrency.format(subtotal)),
                  if (discountAmount > 0) ...[
                    _buildSummaryRow(
                      'Giảm giá${widget.checkoutData['discountCode'] != null ? ' (${widget.checkoutData['discountCode']})' : ''}',
                      '- ${formatCurrency.format(discountAmount)}',
                      valueColor: Colors.green[700],
                    ),
                  ],
                  _buildSummaryRow(
                    'Phí vận chuyển',
                    shippingFee > 0 ? formatCurrency.format(shippingFee) : 'Miễn phí',
                    valueColor: shippingFee == 0 ? Colors.green[700] : null,
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Tổng cộng',
                    formatCurrency.format(total),
                    isBold: true,
                    valueColor: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),

            // Shipping Information
            _buildSummaryCard(
              context,
              'Thông tin giao hàng',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShippingDetail('Người nhận', widget.checkoutData['shippingAddress']['fullName'] ?? ''),
                  _buildShippingDetail('Điện thoại', widget.checkoutData['shippingAddress']['phone'] ?? ''),
                  _buildShippingDetail('Email', widget.checkoutData['shippingAddress']['email'] ?? ''),
                  _buildShippingDetail(
                    'Địa chỉ',
                    '${widget.checkoutData['shippingAddress']['address'] ?? ''}, ${widget.checkoutData['shippingAddress']['city'] ?? ''}',
                  ),
                  if (widget.checkoutData['shippingAddress']['zipCode'] != null)
                    _buildShippingDetail('Mã bưu điện', widget.checkoutData['shippingAddress']['zipCode']),
                  _buildShippingDetail(
                    'Phương thức giao hàng',
                    widget.checkoutData['deliveryOption'] == 'express'
                        ? 'Giao hàng nhanh (1-2 ngày)'
                        : 'Giao hàng tiêu chuẩn (3-5 ngày)',
                  ),
                ],
              ),
            ),

            // Payment Method
            _buildSummaryCard(context, 'Phương thức thanh toán', _buildPaymentMethodInfo(context)),

            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isPlacingOrder ? null : widget.onBack,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: theme.colorScheme.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'QUAY LẠI',
                      style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isPlacingOrder ? null : _placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        _isPlacingOrder
                            ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                ),
                                SizedBox(width: 12),
                                Text('ĐANG XỬ LÝ...', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            )
                            : const Text('ĐẶT HÀNG', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  // Order success is now handled by the OrderSuccessScreen

  Widget _buildOrderError(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
            child: Icon(Icons.error_outline, size: 80, color: Colors.red[600]),
          ),
          const SizedBox(height: 32),
          Text(
            'Đặt hàng không thành công',
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.red[700]),
          ),
          const SizedBox(height: 16),
          Text(
            'Có lỗi xảy ra trong quá trình xử lý đơn hàng. Vui lòng thử lại sau.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text('Chi tiết lỗi: $_errorMessage', textAlign: TextAlign.center, style: TextStyle(color: Colors.red[700])),
          ],
          const SizedBox(height: 48),
          FilledButton(
            onPressed: _placeOrder,
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 56),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('THỬ LẠI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: widget.onBack, child: const Text('QUAY LẠI')),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, Widget content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 16 : 15),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 15,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodInfo(BuildContext context) {
    final paymentMethod = widget.checkoutData['paymentMethod'] ?? 'cod';
    IconData icon;
    String title, description;

    switch (paymentMethod) {
      case 'bank_transfer':
        icon = Icons.account_balance;
        title = 'Chuyển khoản ngân hàng';
        description = 'Vietcombank - Số tài khoản: 1234567890';
        break;
      case 'credit_card':
        icon = Icons.credit_card;
        title = 'Thẻ tín dụng / Ghi nợ';
        description = 'Đã nhập thông tin thẻ';
        break;
      case 'momo':
        icon = Icons.account_balance_wallet;
        title = 'Ví điện tử MoMo';
        description = 'Thanh toán qua ứng dụng MoMo';
        break;
      case 'cod':
      default:
        icon = Icons.money;
        title = 'Thanh toán khi nhận hàng (COD)';
        description = 'Thanh toán bằng tiền mặt khi nhận hàng';
        break;
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(description),
            ],
          ),
        ),
      ],
    );
  }

  void _placeOrder() async {
    setState(() {
      _isPlacingOrder = true;
      _errorMessage = null;
    });

    try {
      // Prepare order request
      final customer = widget.checkoutData['customer']; // Create order with initial pending status (0)
      final discountAmount = widget.checkoutData['discountAmount'] ?? 0.0;
      final originalPrice = widget.checkoutData['originalPrice'] ?? widget.checkoutData['total'];
      final discountId = widget.checkoutData['discountId'];

      final orderRequest = OrderRequest(
        customerId: customer.customerId,
        totalPrice: widget.checkoutData['total'],
        status: 0, // Pending status
        discountId: discountId,
        discountAmount: discountAmount,
        originalPrice: originalPrice,
      );

      // Create order via bloc
      context.read<OrderBloc>().add(OrderAddEvent(request: orderRequest)); // Listen for the result
      await for (final state in context.read<OrderBloc>().stream) {
        if (state is OrderAdded) {
          setState(() {
            _isPlacingOrder = false;
            _orderPlaced = true;
            _orderId = state.orderId;
          }); // Clear the cart after successful order
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthLogin && authState.data.customerId != null) {
            context.read<CartBloc>().add(CartClearEvent(customerId: authState.data.customerId!));
          }

          break;
        } else if (state is OrderError) {
          setState(() {
            _isPlacingOrder = false;
            _errorMessage = state.message;
          });
          break;
        }
      }
    } catch (e) {
      setState(() {
        _isPlacingOrder = false;
        _errorMessage = e.toString();
      });
    }
  }

  Widget _buildCartItem(BuildContext context, dynamic item, NumberFormat formatter) {
    final theme = Theme.of(context);
    final product = item.product;
    final quantity = item.quantity;
    final price = product.price ?? 0;
    final totalPrice = price * quantity;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.productLink ?? 'https://placeholder.pics/svg/60',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[200],
                    child: Icon(Icons.phone_android, color: Colors.grey[400]),
                  ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.model ?? 'Unknown Product',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(formatter.format(price), style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 4),
                Text('Số lượng: $quantity', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatter.format(totalPrice),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
