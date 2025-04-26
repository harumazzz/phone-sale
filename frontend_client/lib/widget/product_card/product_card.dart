import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../model/response/product_response.dart';
import '../../service/convert_helper.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, required this.onPressed});

  final ProductResponse product;

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.0),
      onTap: onPressed,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        margin: const EdgeInsets.all(8.0),
        child: _buildProductCardContent(context),
      ),
    );
  }

  Widget _buildProductCardContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [_buildProductImage(), _buildProductDetails(context)],
    );
  }

  Widget _buildProductImage() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        color: Colors.grey[200],
      ),
      child: () {
        return product.productLink != null
            ? Image.network(product.productLink!, fit: BoxFit.cover)
            : const Icon(Symbols.broken_image, size: 50, color: Colors.grey);
      }(),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8.0,
        children: [_buildModelText(context), _buildPriceAndStock(context)],
      ),
    );
  }

  Widget _buildModelText(BuildContext context) {
    return Text(
      product.model ?? 'Không có model',
      style: Theme.of(context).textTheme.titleMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceAndStock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Giá: ${product.price != null ? ConvertHelper.inVND(product.price!) : 'Không có giá'} VNĐ',
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          'Kho: ${product.stock != null ? product.stock.toString() : 'Không có kho'}',
          style: Theme.of(context).textTheme.bodyMedium,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProductResponse>('product', product));
    properties.add(ObjectFlagProperty<void Function()>.has('onPressed', onPressed));
  }
}
