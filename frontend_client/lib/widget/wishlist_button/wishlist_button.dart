import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc/auth_bloc.dart';
import '../../bloc/wishlist_bloc/wishlist_bloc.dart';
import '../../model/response/product_response.dart';
import '../../model/response/wishlist_response.dart';
import '../../screen/log_in/login_screen.dart';
import '../../service/ui_helper.dart';

class WishlistButton extends StatefulWidget {
  const WishlistButton({super.key, required this.product});

  final ProductResponse product;

  @override
  State<WishlistButton> createState() => _WishlistButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProductResponse>('product', product));
  }
}

class _WishlistButtonState extends State<WishlistButton> {
  bool _isInWishlist = false;
  bool _isLoading = false;
  int? _wishlistId;

  @override
  void initState() {
    super.initState();
    _checkIfInWishlist();
  }

  void _checkIfInWishlist() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthLogin) {
      return;
    }

    final wishlistState = context.read<WishlistBloc>().state;
    if (wishlistState is WishlistLoaded) {
      final wishlistItem = wishlistState.wishlists.firstWhere(
        (item) => item.productId == widget.product.productId,
        orElse: () => const WishlistResponse(),
      );

      setState(() {
        _isInWishlist = wishlistItem.wishlistId != null;
        _wishlistId = wishlistItem.wishlistId;
      });
    }
  }

  Future<void> _toggleWishlist() async {
    final authState = context.read<AuthBloc>().state;

    // If user is not logged in, prompt login
    if (authState is! AuthLogin) {
      final shouldLogin = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Đăng nhập để tiếp tục'),
              content: const Text('Bạn cần đăng nhập để thêm sản phẩm vào danh sách yêu thích'),
              actions: [
                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('HỦY')),
                ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('ĐĂNG NHẬP')),
              ],
            ),
      );

      if (shouldLogin == true) {
        if (mounted) {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      }
      return;
    }

    // Toggle wishlist status
    setState(() {
      _isLoading = true;
    });

    try {
      final customerId = authState.data.customerId!;

      if (_isInWishlist && _wishlistId != null) {
        // Remove from wishlist
        context.read<WishlistBloc>().add(WishlistRemove(wishlistId: _wishlistId!));
        setState(() {
          _isInWishlist = false;
          _wishlistId = null;
        });

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa khỏi danh sách yêu thích')));
      } else {
        // Add to wishlist
        context.read<WishlistBloc>().add(WishlistAdd(customerId: customerId, productId: widget.product.productId!));

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm vào danh sách yêu thích')));

        setState(() {
          _isInWishlist = true;
        });
      }
    } catch (e) {
      if (mounted) {
        await UIHelper.showErrorDialog(context: context, message: e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _isLoading ? null : _toggleWishlist,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child:
            _isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Icon(
                  _isInWishlist ? Symbols.favorite : Symbols.favorite,
                  size: 20,
                  color: _isInWishlist ? Colors.red : Colors.grey,
                ),
      ),
    );
  }
}
