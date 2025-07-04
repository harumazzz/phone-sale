import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ProductList extends StatelessWidget {
  const ProductList({super.key, required this.builder, required this.size});

  final Widget Function(BuildContext context, int index) builder;

  final int size;
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(4.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7, // Tỷ lệ cao hơn cho thẻ sản phẩm đẹp hơn
        ),
        delegate: SliverChildBuilderDelegate(builder, childCount: size),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<Widget Function(BuildContext context, int index)>.has('builder', builder));
    properties.add(IntProperty('size', size));
  }
}
