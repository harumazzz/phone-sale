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
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'vi_VN',
      decimalDigits: 0,
    );
    final product = item.product;
    final quantity = item.quantity;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[200],
              child: const Icon(
                Symbols.image_not_supported,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.model ?? 'Sản phẩm không tên',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatCurrency.format(product.price ?? 0),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildQuantityButton(
                        context: context,
                        icon: Symbols.remove,
                        onPressed: quantity > 1 ? onDecrement : onRemove,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          '$quantity',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      _buildQuantityButton(
                        context: context,
                        icon: Symbols.add,
                        onPressed: onIncrement,
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          Symbols.delete_outline,
                          color: Colors.red[700],
                        ),
                        onPressed: onRemove,
                        tooltip: 'Xóa khỏi giỏ hàng',
                      ),
                    ],
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
    return Material(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(icon, size: 20, color: Colors.black87),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CartItemData>('item', item));
    properties.add(
      ObjectFlagProperty<void Function()>.has('onIncrement', onIncrement),
    );
    properties.add(
      ObjectFlagProperty<void Function()>.has('onDecrement', onDecrement),
    );
    properties.add(
      ObjectFlagProperty<void Function()>.has('onRemove', onRemove),
    );
  }
}
