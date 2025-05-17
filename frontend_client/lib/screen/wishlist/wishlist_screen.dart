import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/product_bloc/product_bloc.dart';
import '../../bloc/wishlist_bloc/wishlist_bloc.dart';
import '../../model/response/product_response.dart';
import '../../service/ui_helper.dart';
import '../../widget/custom_appbar/custom_appbar.dart';
import '../../widget/product_card/product_card.dart';
import '../log_in/login_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthLogin) {
      return;
    }

    setState(() {});

    try {
      final customerId = authState.data.customerId!;
      context.read<WishlistBloc>().add(WishlistFetch(customerId: customerId));
    } catch (e) {
      if (mounted) {
        await UIHelper.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _removeFromWishlist(int wishlistId) async {
    setState(() {});

    try {
      context.read<WishlistBloc>().add(WishlistRemove(wishlistId: wishlistId));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa khỏi danh sách yêu thích')));
    } catch (e) {
      if (mounted) {
        await UIHelper.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          const CustomAppbar(title: Text('Danh sách yêu thích'), showBackButton: true),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: authState is AuthLogin ? _buildWishlistItems() : SliverToBoxAdapter(child: _buildLoginPrompt()),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItems() {
    return BlocConsumer<WishlistBloc, WishlistState>(
      listener: (context, state) {
        if (state is WishlistError) {
          UIHelper.showErrorDialog(context: context, message: state.message);
        }
      },
      builder: (context, state) {
        if (state is WishlistLoading) {
          return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
        }

        if (state is WishlistLoaded) {
          if (state.wishlists.isEmpty) {
            return const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Symbols.favorite, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Danh sách yêu thích trống', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text(
                        'Bạn chưa thêm sản phẩm nào vào danh sách yêu thích',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Get product information for each wishlist item
          return BlocBuilder<ProductBloc, ProductState>(
            builder: (context, productState) {
              if (productState is ProductLoaded) {
                // Map wishlist items to products
                final wishlistProducts =
                    state.wishlists
                        .map(
                          (wishlist) => productState.products.firstWhere(
                            (product) => product.productId == wishlist.productId,
                            orElse: ProductResponse.new,
                          ),
                        )
                        .where((product) => product.productId != null)
                        .toList();

                return SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final product = wishlistProducts[index];
                    final wishlist = state.wishlists.firstWhere((w) => w.productId == product.productId);

                    return Stack(
                      children: [
                        ProductCard(
                          imageUrl: product.productLink ?? '',
                          title: product.model ?? 'Unknown',
                          price: product.price?.toString() ?? '0',
                          product: product,
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                            ),
                            child: IconButton(
                              icon: const Icon(Symbols.favorite, color: Colors.red),
                              onPressed: () => _removeFromWishlist(wishlist.wishlistId!),
                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                              padding: const EdgeInsets.all(8),
                              iconSize: 20,
                            ),
                          ),
                        ),
                      ],
                    );
                  }, childCount: wishlistProducts.length),
                );
              }

              // If products aren't loaded yet, show a placeholder
              return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
            },
          );
        }

        // Initial state
        return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildLoginPrompt() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 2), blurRadius: 6)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Symbols.favorite, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Đăng nhập để xem danh sách yêu thích',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn cần đăng nhập để sử dụng tính năng này',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('ĐĂNG NHẬP'),
          ),
        ],
      ),
    );
  }
}
