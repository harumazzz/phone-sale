import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../model/cart_item_data.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });
  final CartItemData item;
  final void Function() onIncrement;
  final void Function() onDecrement;
  final void Function() onRemove;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    final product = item.product;
    final quantity = item.quantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    product.productLink != null
                        ? Image.network(
                          product.productLink!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Symbols.image_not_supported, color: Colors.grey, size: 32));
                          },
                        )
                        : const Center(child: Icon(Symbols.image_not_supported, color: Colors.grey, size: 32)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product.model ?? 'Sản phẩm không tên',
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.grey[600], size: 20),
                        onPressed: onRemove,
                        tooltip: 'Xóa khỏi giỏ hàng',
                        style: IconButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(24, 24)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency.format(product.price ?? 0),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        'Số lượng:',
                        style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      const Spacer(),
                      _buildQuantityButton(
                        context: context,
                        icon: Symbols.remove,
                        onPressed: quantity > 1 ? onDecrement : onRemove,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$quantity',
                          style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                        ),
                      ),
                      _buildQuantityButton(context: context, icon: Symbols.add, onPressed: onIncrement),
                    ],
                  ),
                  if ((product.price ?? 0) > 0 && quantity > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Tổng: ', style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700])),
                          Text(
                            formatCurrency.format((product.price ?? 0) * quantity),
                            style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantityButton({
    required BuildContext context,
    required IconData icon,
    required void Function() onPressed,
  }) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Icon(icon, size: 16, color: theme.colorScheme.primary, weight: 700),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CartItemData>('item', item));
    properties.add(ObjectFlagProperty<void Function()>.has('onIncrement', onIncrement));
    properties.add(ObjectFlagProperty<void Function()>.has('onDecrement', onDecrement));
    properties.add(ObjectFlagProperty<void Function()>.has('onRemove', onRemove));
  }
}
