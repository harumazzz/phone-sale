import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../screen/wishlist/wishlist_screen.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, this.title, this.actions, this.showBackButton = false, this.onBackPressed});

  final Widget? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final void Function()? onBackPressed;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: title,
      actions:
          actions ??
          [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const WishlistScreen()));
              },
              icon: const Icon(Symbols.favorite),
              tooltip: 'Yêu thích',
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              icon: const Icon(Symbols.shopping_cart),
              tooltip: 'Giỏ hàng',
            ),
            const SizedBox(width: 8),
          ],
      leading:
          showBackButton
              ? IconButton(
                onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                icon: const Icon(Symbols.arrow_back_ios_new_rounded),
              )
              : null,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 64,
      centerTitle: false,
      forceElevated: true,
      shadowColor: Colors.black12,
      surfaceTintColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('showBackButton', showBackButton));
    properties.add(ObjectFlagProperty<void Function()?>.has('onBackPressed', onBackPressed));
  }
}
