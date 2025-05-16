import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../api/order_api.dart';
import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
import '../../bloc/order_bloc/order_bloc.dart';
import '../../repository/order_repository.dart';
import '../checkout/checkout_screen.dart';
import 'cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthLogin && authState.data.customerId != null && mounted) {
        context.read<CartBloc>().add(CartLoadEvent(customerId: authState.data.customerId!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatCurrency = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 3);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading || state is CartInitial) {
                    return Center(child: CircularProgressIndicator(color: theme.colorScheme.primary));
                  }

                  if (state is CartError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(color: Colors.red[50], shape: BoxShape.circle),
                              child: Icon(Icons.error_outline, color: Colors.red[400], size: 60),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Không thể tải giỏ hàng',
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Lỗi: ${state.message}',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text('Thử lại'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                textStyle: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: _reloadData,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is CartLoaded) {
                    if (state.isEmpty) {
                      return _buildEmptyCart(context);
                    } else {
                      final double totalPrice = state.carts.fold(
                        0.0,
                        (sum, item) => sum + (item.product.price ?? 0) * item.quantity,
                      );
                      return Stack(
                        children: [
                          // ListView for cart items
                          ListView.builder(
                            padding: const EdgeInsets.only(
                              top: 16,
                            ), // Add extra bottom padding for the checkout section
                            itemCount: state.size,
                            itemBuilder: (context, index) {
                              final item = state[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: CartItemCard(
                                  item: item,
                                  onIncrement: () {
                                    if (item.quantity < 10) {
                                      // Giới hạn số lượng tối đa
                                      context.read<CartBloc>().add(
                                        CartEditEvent(
                                          cartId: item.cartInfo.cartId,
                                          customerId: item.cartInfo.customerId,
                                          productId: item.productId,
                                          quantity: item.quantity + 1,
                                        ),
                                      );

                                      // Reload after successful edit
                                      context.read<CartBloc>().stream.listen((state) {
                                        if (state is CartEdited) {
                                          _reloadData();
                                        }
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Số lượng tối đa cho mỗi sản phẩm là 10'),
                                          behavior: SnackBarBehavior.floating,
                                        ),
                                      );
                                    }
                                  },
                                  onDecrement: () {
                                    if (item.quantity > 1) {
                                      context.read<CartBloc>().add(
                                        CartEditEvent(
                                          cartId: item.cartInfo.cartId,
                                          customerId: item.cartInfo.customerId,
                                          productId: item.productId,
                                          quantity: item.quantity - 1,
                                        ),
                                      );

                                      // Reload after successful edit
                                      context.read<CartBloc>().stream.listen((state) {
                                        if (state is CartEdited) {
                                          _reloadData();
                                        }
                                      });
                                    }
                                  },
                                  onRemove: () {
                                    // Lưu lại item để có thể hoàn tác
                                    final deletedItem = item;

                                    // Xóa item
                                    context.read<CartBloc>().add(CartDeleteEvent(cartId: item.cartInfo.cartId));

                                    // Reload sau khi xóa thành công
                                    context.read<CartBloc>().stream.listen((state) {
                                      if (state is CartDeleted && context.mounted) {
                                        _reloadData();

                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Đã xóa ${deletedItem.product.model} khỏi giỏ hàng'),
                                            behavior: SnackBarBehavior.floating,
                                            action: SnackBarAction(
                                              label: 'HOÀN TÁC',
                                              onPressed: () {
                                                // Thêm lại sản phẩm vào giỏ hàng
                                                final authState = BlocProvider.of<AuthBloc>(context).state;
                                                if (authState is AuthLogin && authState.data.customerId != null) {
                                                  context.read<CartBloc>().add(
                                                    CartAddEvent(
                                                      customerId: authState.data.customerId!,
                                                      productId: deletedItem.productId,
                                                      quantity: deletedItem.quantity,
                                                    ),
                                                  );

                                                  // Reload sau khi thêm lại thành công
                                                  context.read<CartBloc>().stream.listen((state) {
                                                    if (state is CartAdded) {
                                                      _reloadData();
                                                    }
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          // Position the checkout section at the bottom of the screen
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: _buildCheckoutSection(context, totalPrice, formatCurrency),
                          ),
                        ],
                      );
                    }
                  }

                  return const Center(child: Text('Trạng thái không xác định.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), offset: const Offset(0, 2), blurRadius: 6)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(backgroundColor: theme.colorScheme.primary.withAlpha(25)),
              ),
              const SizedBox(width: 16),
              Text('Giỏ hàng của bạn', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // Show confirmation dialog before clearing the cart
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Xóa giỏ hàng'),
                          content: const Text('Bạn có chắc chắn muốn xóa tất cả sản phẩm khỏi giỏ hàng?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
                            FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                                final authState = context.read<AuthBloc>().state;
                                if (authState is AuthLogin && authState.data.customerId != null) {
                                  context.read<CartBloc>().add(CartClearEvent(customerId: authState.data.customerId!));
                                }
                              },
                              style: FilledButton.styleFrom(backgroundColor: Colors.red),
                              child: const Text('Xóa tất cả'),
                            ),
                          ],
                        ),
                  );
                },
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Xóa tất cả',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withAlpha(76), shape: BoxShape.circle),
            child: Icon(Icons.shopping_cart_outlined, size: 80, color: theme.colorScheme.primary.withAlpha(204)),
          ),
          const SizedBox(height: 32),
          Text('Giỏ hàng trống', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Bạn chưa thêm bất kỳ sản phẩm nào vào giỏ hàng',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('Tiếp tục mua sắm'),
            style: FilledButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, double totalPrice, NumberFormat formatter) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), offset: const Offset(0, -3), blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tạm tính:', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
              Text(
                formatter.format(totalPrice),
                style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Phí vận chuyển:', style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
              Text(
                'Miễn phí',
                style: theme.textTheme.bodyLarge?.copyWith(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng tiền:', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text(
                formatter.format(totalPrice),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              if (BlocProvider.of<AuthBloc>(context).state is AuthLogin) {
                // Navigate to checkout screen with access to both order and cart blocs
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => OrderBloc(orderRepository: const OrderRepository(OrderApi())),
                            ),
                            BlocProvider.value(value: context.read<CartBloc>()),
                          ],
                          child: const CheckoutScreen(),
                        ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Vui lòng đăng nhập để tiến hành thanh toán'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: const Text('THANH TOÁN NGAY'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              minimumSize: const Size(double.infinity, 56),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _reloadData() {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthLogin && authState.data.customerId != null) {
      context.read<CartBloc>().add(CartLoadEvent(customerId: authState.data.customerId!));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Không thể tải lại: Người dùng chưa đăng nhập.')));
    }
  }
}
