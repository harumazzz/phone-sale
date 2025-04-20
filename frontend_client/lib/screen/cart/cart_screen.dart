import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/cart_bloc/cart_bloc.dart';
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
      if (authState is AuthLogin &&
          authState.data.customerId != null &&
          mounted) {
        context.read<CartBloc>().add(
          CartLoadEvent(customerId: authState.data.customerId!),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final formatCurrency = NumberFormat.simpleCurrency(
      locale: 'vi_VN',
      decimalDigits: 0,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CartError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Lỗi tải giỏ hàng: ${state.message}',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: const Text('Thử lại'),
                      onPressed: _reloadData,
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is CartLoaded) {
            if (state.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Giỏ hàng của bạn đang trống.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Tiếp tục mua sắm'),
                    ),
                  ],
                ),
              );
            } else {
              final double totalPrice = state.carts.fold(
                0.0,
                (sum, item) => sum + (item.product.price ?? 0) * item.quantity,
              );
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      itemCount: state.size,
                      itemBuilder: (context, index) {
                        final item = state[index];
                        return CartItemCard(
                          item: item,
                          onIncrement: () {
                            // context.read<CartBloc>().add(
                            // );
                          },
                          onDecrement: () {
                            // context.read<CartBloc>().add(
                            //   CartItemDecrementEvent(productId: productId),
                            // );
                          },
                          onRemove: () {
                            // context.read<CartBloc>().add(
                            //   CartItemRemoveEvent(productId: productId),
                            // );
                          },
                        );
                      },
                    ),
                  ),
                  const Divider(height: 1, thickness: 1),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng cộng:',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              formatCurrency.format(totalPrice),
                              style: Theme.of(
                                context,
                              ).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.payment),
                          label: const Text('Thanh toán'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            textStyle: Theme.of(context).textTheme.labelLarge,
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Chức năng thanh toán chưa được thực hiện.',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
          return const Center(child: Text('Trạng thái không xác định.'));
        },
      ),
    );
  }

  void _reloadData() {
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthLogin && authState.data.customerId != null) {
      context.read<CartBloc>().add(
        CartLoadEvent(customerId: authState.data.customerId!),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Không thể tải lại: Người dùng chưa đăng nhập.'),
        ),
      );
    }
  }
}
