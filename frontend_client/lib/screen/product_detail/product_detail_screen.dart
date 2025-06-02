import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/product_bloc/product_bloc.dart';
import '../../model/response/product_response.dart';
import '../../widget/product_card/product_card.dart';
import '../../widget/product_list/product_list.dart';
import '../../widget/wishlist_button/wishlist_button.dart';
import '../cart/cart_screen.dart' show CartScreen;

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.product});
  final ProductResponse product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      extendBodyBehindAppBar: true,
      body: BlocListener<CartBloc, CartState>(
        listener: (context, state) async {
          if (state is CartAdded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Symbols.check_circle_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text('Đã thêm ${product.model} vào giỏ hàng', style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.green[700],
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'XEM GIỎ HÀNG',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartScreen()));
                  },
                ),
              ),
            );
          }
          if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text('Lỗi: ${state.message}')),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.red[700],
              ),
            );
          }
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildAppBar(context),
            _buildProductImage(),
            _buildProductDetails(context),
            _buildBuyNowButton(context),
            SliverPadding(padding: const EdgeInsets.only(bottom: 16), sliver: _buildRecommended(context)),
            SliverPadding(padding: const EdgeInsets.only(bottom: 32), sliver: _buildRecommendedItems(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommended(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Sản phẩm tương tự', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    children: [
                      Text('Xem tất cả', style: TextStyle(color: theme.colorScheme.primary)),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 12, color: theme.colorScheme.primary),
                    ],
                  ),
                ),
              ],
            ),
          ],
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
                  .where((e) => e.categoryId == product.categoryId && e.productId != product.productId)
                  .toList();
          return ProductList(
            builder: (context, index) {
              return ProductCard(
                imageUrl: filteredList[index].productLink!,
                title: filteredList[index].model!,
                price: filteredList[index].price!.toString(),
                product: filteredList[index],
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
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: kToolbarHeight,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withAlpha(102), Colors.transparent],
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white.withAlpha(230), shape: BoxShape.circle),
          child: Icon(Icons.arrow_back, color: theme.colorScheme.primary, size: 20),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [Container(margin: const EdgeInsets.only(right: 16), child: WishlistButton(product: product))],
    );
  }

  Widget _buildProductImage() {
    return SliverToBoxAdapter(
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);

          return Container(
            height: 380,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: 'product_${product.productId}',
                    child:
                        product.productLink != null
                            ? Image.network(
                              product.productLink!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Symbols.broken_image, size: 50, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text('Không thể tải hình ảnh', style: TextStyle(color: Colors.grey[600])),
                                    ],
                                  ),
                                );
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                  ),
                                );
                              },
                            )
                            : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Symbols.broken_image, size: 50, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  Text('Không có hình ảnh', style: TextStyle(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withAlpha(230),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.new_releases, size: 16, color: Colors.white),
                        SizedBox(width: 4),
                        Text('Mới', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.model ?? 'Model không có',
                        style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Chính hãng',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          Text(' 4.8', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
                          Text(' (142)', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      product.formattedPriceVnd,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if ((product.stock ?? 0) > 0)
                      const Text('Còn hàng', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500))
                    else
                      const Text('Hết hàng', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text('Thông tin chi tiết', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildSpecsCard(context),
            const SizedBox(height: 24),
            Text('Mô tả sản phẩm', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text(product.description ?? 'Không có mô tả cho sản phẩm này.', style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecsCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withAlpha(51)),
      ),
      child: Column(
        children: [
          _buildSpecRow(context, 'Mẫu mã', product.model ?? '-'),
          const Divider(height: 24),
          _buildSpecRow(context, 'Hãng sản xuất', 'Chưa có thông tin'),
          const Divider(height: 24),
          _buildSpecRow(context, 'Màu sắc', 'Chưa có thông tin'),
          const Divider(height: 24),
          _buildSpecRow(context, 'Số lượng còn lại', '${product.stock ?? 0} sản phẩm'),
        ],
      ),
    );
  }

  Widget _buildSpecRow(BuildContext context, String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildBuyNowButton(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle buy action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      foregroundColor: theme.colorScheme.onPrimaryContainer,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('MUA NGAY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      final authState = BlocProvider.of<AuthBloc>(context).state;
                      if (authState is AuthLogin && authState.data.customerId != null) {
                        context.read<CartBloc>().add(
                          CartAddEvent(
                            customerId: authState.data.customerId!,
                            productId: product.productId!,
                            quantity: 1,
                          ),
                        );
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('THÊM VÀO GIỎ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(),
          ],
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
