import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import '../../bloc/product_bloc/product_bloc.dart';
import '../../model/response/product_response.dart';
import '../../service/convert_helper.dart';
import '../../widget/product_card/product_card.dart';
import '../../widget/product_list/product_list.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductResponse product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          _buildProductImage(),
          _buildProductDetails(context),
          _buildBuyNowButton(context),
          _buildRecommended(context),
          _buildRecommendedItems(context),
        ],
      ),
    );
  }

  Future<void> _onMove(BuildContext context, ProductResponse product) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ProductDetailScreen(product: product);
        },
      ),
    );
  }

  Widget _buildRecommended(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          'Sản phẩm liên quan',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildRecommendedItems(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoaded) {
          final filteredList =
              state.products
                  .where(
                    (e) =>
                        e.categoryId == product.categoryId &&
                        e.productId != product.productId,
                  )
                  .toList();
          return ProductList(
            builder: (context, index) {
              return ProductCard(
                product: filteredList[index],
                onPressed: () async {
                  return await _onMove(context, filteredList[index]);
                },
              );
            },
            size: filteredList.length,
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: kToolbarHeight,
      pinned: true,
      actions: [
        IconButton(
          icon: const Icon(Symbols.favorite),
          onPressed: () {
            // Handle add to favorites
          },
        ),
      ],
    );
  }

  Widget _buildProductImage() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.grey,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: const Center(child: Icon(Symbols.image)),
          ),
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.0,
              children: [
                _buildProductRow(
                  context,
                  Symbols.device_hub,
                  product.model ?? 'Model không có',
                ),
                _buildProductDescription(context),
                _buildPriceRow(context),
                _buildStockRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductRow(BuildContext context, IconData icon, String text) {
    return Row(
      spacing: 8.0,
      children: [
        Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildProductDescription(BuildContext context) {
    return Column(
      spacing: 8.0,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả sản phẩm',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          product.description ?? 'Mô tả không có',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        Icon(
          Symbols.attach_money,
          size: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          'Thành tiền: ${ConvertHelper.inVND(product.price!)} VNĐ',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildStockRow(BuildContext context) {
    return Row(
      spacing: 8.0,
      children: [
        Icon(
          Symbols.store,
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          'Số lượng: ${product.stock ?? 0}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.normal),
        ),
      ],
    );
  }

  Widget _buildBuyNowButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            // Handle buy action
          },
          icon: const Icon(Symbols.shopping_cart),
          label: const Text('Mua ngay'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            elevation: 3,
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProductResponse>('product', product));
  }
}
