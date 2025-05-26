import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class OrderSummary extends StatelessWidget {
  const OrderSummary({super.key, required this.checkoutData, required this.onUpdateData, required this.onNext});
  final Map<String, dynamic> checkoutData;
  final Function(Map<String, dynamic>) onUpdateData;
  final void Function() onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', decimalDigits: 0, symbol: '₫');
    final cartItems = checkoutData['cartItems'] ?? [];
    final subtotal = checkoutData['subtotal'] ?? 0.0;
    final discountAmount = checkoutData['discountAmount'] ?? 0.0;
    final finalPrice = checkoutData['finalPrice'] ?? subtotal;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Chi tiết đơn hàng', Symbols.receipt_long),
            const SizedBox(height: 16),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ...cartItems.map<Widget>((item) => _buildOrderItem(context, item, formatCurrency)).toList(),
                    const Divider(height: 32),
                    _buildPriceRow('Tạm tính', formatCurrency.format(subtotal), false),
                    if (discountAmount > 0)
                      _buildPriceRow(
                        'Giảm giá',
                        '- ${formatCurrency.format(discountAmount)}',
                        false,
                        valueColor: Colors.green[700],
                      ),
                    _buildPriceRow('Phí vận chuyển', 'Miễn phí', false, valueColor: Colors.green[700]),
                    const Divider(height: 24),
                    _buildPriceRow(
                      'Tổng tiền',
                      formatCurrency.format(finalPrice),
                      true,
                      valueColor: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildNoteSection(context),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'TIẾP TỤC',
                  style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildOrderItem(BuildContext context, dynamic item, NumberFormat formatter) {
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
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product.productLink ?? 'https://placeholder.pics/svg/80',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.phone_android, color: Colors.grey[400]),
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.model ?? 'Unknown Product',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(formatter.format(price), style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 4),
                Text('Số lượng: $quantity', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatter.format(totalPrice),
                style: theme.textTheme.titleMedium?.copyWith(
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

  Widget _buildPriceRow(String label, String value, bool isBold, {Color? valueColor}) {
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

  Widget _buildNoteSection(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController noteController = TextEditingController();
    noteController.text = checkoutData['orderNote'] ?? '';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ghi chú đơn hàng', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Nhập ghi chú cho đơn hàng (nếu có)',
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: theme.colorScheme.primary),
                ),
              ),
              onChanged: (value) {
                onUpdateData({'orderNote': value});
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Map<String, dynamic>>('checkoutData', checkoutData));
    properties.add(ObjectFlagProperty<Function(Map<String, dynamic> p1)>.has('onUpdateData', onUpdateData));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onNext', onNext));
  }
}
